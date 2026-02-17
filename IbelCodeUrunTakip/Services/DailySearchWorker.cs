using IbelCode.Data;
using IbelCode.Service;
using Microsoft.EntityFrameworkCore;

namespace IbelCodeUrunTakip.Services
{
    public class DailySearchWorker : BackgroundService
    {
        private readonly IServiceProvider _services;
        private readonly ILogger<DailySearchWorker> _logger;

        public DailySearchWorker(IServiceProvider services, ILogger<DailySearchWorker> logger)
        {
            _services = services;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                using (var scope = _services.CreateScope())
                {
                    var dbFactory = scope.ServiceProvider.GetRequiredService<IDbContextFactory<ApplicationDbContext>>();
                    using var context = dbFactory.CreateDbContext();

                    // 1. Veritabanından ayarlanan saati oku
                    var timeSetting = await context.AppSettings
                        .FirstOrDefaultAsync(s => s.SettingKey == "ServiceExecutionTime");

                    string scheduledTime = timeSetting?.SettingValue ?? "03:00"; // Yoksa varsayılan 03:00
                    string currentTime = DateTime.Now.ToString("HH:mm");

                    // 2. Saat geldi mi kontrol et
                    if (currentTime == scheduledTime)
                    {
                        var searchService = scope.ServiceProvider.GetRequiredService<SearchService>();
                        await searchService.UpdateAllLoggedSearches();

                        // Aynı dakika içinde tekrar çalışmaması için 61 saniye bekle
                        await Task.Delay(61000, stoppingToken);
                    }
                }

                // Her dakikada bir kontrol et
                await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
            }
        }
    }
}
