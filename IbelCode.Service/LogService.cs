using IbelCode.Core.Interfaces;
using IbelCode.Core.Models;
using IbelCode.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IbelCode.Service
{
    public class LogService : ILogService
    {
        private readonly IDbContextFactory<ApplicationDbContext> _dbFactory;

        public LogService(IDbContextFactory<ApplicationDbContext> dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<int> CreateSessionAsync(string fileName, int totalRows, string userId)
        {
            using var context = _dbFactory.CreateDbContext();
            var session = new TransferSession
            {
                FileName = fileName,
                TotalRows = totalRows,
                StartTime = DateTime.Now,
                Status = "İşleniyor",
                UserId = userId
            };
            context.TransferSessions.Add(session);
            await context.SaveChangesAsync();
            return session.Id;
        }

        public async Task AddLogAsync(int sessionId, string message, string type, string? sku = null, string? variantId = null)
        {
            using var context = _dbFactory.CreateDbContext();
            var log = new TransferLog
            {
                TransferSessionId = sessionId,
                LogTime = DateTime.Now,
                Message = message,
                LogType = type,
                SKU = sku,
                VariantId = variantId
            };
            context.TransferLogs.Add(log);
            await context.SaveChangesAsync();
        }


        public async Task UpdateSessionStatusAsync(int sessionId, string status, int processedRows, int totalRows = 0)
        {
            using var context = _dbFactory.CreateDbContext();
            var session = await context.TransferSessions.FindAsync(sessionId);

            if (session != null)
            {
                session.Status = status;
                session.ProcessedRows = processedRows;

                // Eğer totalRows parametresi 0'dan büyük gönderildiyse (analiz sonrası) güncelle
                if (totalRows > 0)
                {
                    session.TotalRows = totalRows;
                }

                if (status == "Tamamlandı" || status == "İptal Edildi" || status == "Hata ile Bitti")
                {
                    session.EndTime = DateTime.Now;
                }

                await context.SaveChangesAsync();
            }
        }
        public async Task<List<TransferSession>> GetSessionsAsync(DateTime? startDate = null, DateTime? endDate = null)
        {
            using var context = _dbFactory.CreateDbContext();
            var query = context.TransferSessions.AsQueryable();

            if (startDate.HasValue)
            {
                // Seçilen günün başlangıcından itibaren (00:00:00)
                query = query.Where(s => s.StartTime >= startDate.Value.Date);
            }

            if (endDate.HasValue)
            {
                // Seçilen günün sonuna kadar (23:59:59)
                var endLimit = endDate.Value.Date.AddDays(1).AddTicks(-1);
                query = query.Where(s => s.StartTime <= endLimit);
            }

            return await query.OrderByDescending(s => s.StartTime).ToListAsync();
        }

        public async Task<List<TransferLog>> GetLogsBySessionIdAsync(int sessionId)
        {
            using var context = _dbFactory.CreateDbContext();
            return await context.TransferLogs
                .Where(l => l.TransferSessionId == sessionId)
                .OrderByDescending(l => l.LogTime)
                .ToListAsync();
        }

        public async Task GirisLoglaAsync(string username, string ip = "", string browser = "")
        {
            using var context = _dbFactory.CreateDbContext();
            var sonLogZamani = DateTime.Now.AddHours(-12);
            bool zatenLoglandi = await context.KullaniciLogs
                .AnyAsync(l => l.KullaniciAdi == username && l.GirisTarihi > sonLogZamani);

            if (zatenLoglandi)
            {
                return; // Zaten kaydı var, metottan çık ve hiçbir şey yapma.
            }

            var log = new KullaniciLog
            {
                KullaniciAdi = username,
                GirisTarihi = DateTime.Now,
                IpAdresi = ip,
                TarayiciBilgisi = CleanBrowserInfo(browser)
            };
            context.KullaniciLogs.Add(log);
            await context.SaveChangesAsync();
        }
        private string CleanBrowserInfo(string userAgent)
        {
            if (string.IsNullOrEmpty(userAgent)) return "Bilinmiyor";

            // En yaygın tarayıcıları kontrol et
            if (userAgent.Contains("Edg/")) return "Microsoft Edge";
            if (userAgent.Contains("Chrome/")) return "Google Chrome";
            if (userAgent.Contains("Firefox/")) return "Mozilla Firefox";
            if (userAgent.Contains("Safari/") && !userAgent.Contains("Chrome")) return "Safari";

            return "Diğer/Mobil";
        }
    }
}
