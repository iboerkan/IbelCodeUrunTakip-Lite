using IbelCode.Core.DTOs;
using IbelCode.Core.Interfaces;
using IbelCode.Core.Models;
using IbelCode.Data;           // ApplicationDbContext ve ApplicationUser burada olmalý
using IbelCode.Service;
using IbelCodeUrunTakip.Client.Pages;
using IbelCodeUrunTakip.Components;
using IbelCodeUrunTakip.Components.Account; // Yardýmcý sýnýflarýn olduðu klasör
using IbelCodeUrunTakip.Services;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Server;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Serilog;


var builder = WebApplication.CreateBuilder(args);
// Program.cs en üstüne

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .WriteTo.File("logs/log-.txt", rollingInterval: RollingInterval.Day) // Her gün yeni dosya açar
    .CreateLogger();
builder.Host.UseSerilog();
// 1. Veritabaný Baðlantýsý (appsettings.json içindeki DefaultConnection'ý okur)
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection")
    ?? throw new InvalidOperationException("Baðlantý dizesi 'DefaultConnection' bulunamadý.");

/*builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));*/

/*builder.Services.AddDbContextFactory<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));
*/
builder.Services.AddDbContextFactory<ApplicationDbContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        sqlServerOptionsAction: sqlOptions =>
        {
            // --- EKLENMESÝ GEREKEN KISIM ---
            sqlOptions.EnableRetryOnFailure(
                maxRetryCount: 5, // Kaç kere tekrar denesin?
                maxRetryDelay: TimeSpan.FromSeconds(30), // Denemeler arasý ne kadar beklesin?
                errorNumbersToAdd: null // Hangi SQL hata kodlarýnda denesin? (null = varsayýlanlar)
            );
            // -------------------------------
        });
});
// 2. Identity Sistemi Yapýlandýrmasý (Giriþ yapamama sorununu çözen kritik kýsým)
builder.Services.AddCascadingAuthenticationState();
builder.Services.AddScoped<IdentityUserAccessor>();
builder.Services.AddScoped<IdentityRedirectManager>();
builder.Services.AddScoped<AuthenticationStateProvider, IdentityRevalidatingAuthenticationStateProvider>();

// AddIdentityCore ve AddAuthentication bloklarýný sildik, yerine bunu koyduk:
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options => {
    // Þifre ve Giriþ Politikalarý
    options.SignIn.RequireConfirmedAccount = false; // Email onayý gerekmiyorsa false yapýn
    options.Password.RequireDigit = false;
    options.Password.RequiredLength = 6;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequireUppercase = false;
    options.User.RequireUniqueEmail = true;
    options.Lockout.AllowedForNewUsers = true;
    options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromDays(36500);
})
.AddEntityFrameworkStores<ApplicationDbContext>()
.AddDefaultTokenProviders();

builder.Services.AddScoped<IUserClaimsPrincipalFactory<ApplicationUser>, MyUserClaimsPrincipalFactory>();

builder.Services.ConfigureApplicationCookie(options =>
{
    options.LoginPath = "/Account/Login";
    options.AccessDeniedPath = "/Account/AccessDenied"; // Sayfanýn adresiyle ayný olmalý
});

builder.Services.AddAuthorizationBuilder();

builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages();


// 3. Blazor Bileþenleri ve DevExpress
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents()
    .AddInteractiveWebAssemblyComponents();

builder.Services.AddDevExpressBlazor();

// 4. Özel Servisler
builder.Services.AddScoped<DxThemesService>();
builder.Services.AddHttpClient(); // SerpApi vb. dýþ aramalar için
builder.Services.AddAuthorizationBuilder();

builder.Services.AddServerSideBlazor()
    .AddHubOptions(options =>
    {
        options.MaximumReceiveMessageSize = 10*1024 * 1024; // 10MB'a yükselt
        options.EnableDetailedErrors = true;
        options.HandshakeTimeout = TimeSpan.FromSeconds(30);
        options.KeepAliveInterval = TimeSpan.FromSeconds(15);
    });
builder.Services.Configure<CircuitOptions>(options =>
{
    options.DisconnectedCircuitRetentionPeriod = TimeSpan.FromMinutes(10);
});
builder.Services.AddSignalR(options => {
    options.EnableDetailedErrors = true; // Geliþtirme aþamasýnda hatalarý detaylý görmek için
});
builder.Services.AddHttpContextAccessor();
builder.Services.AddHttpClient();
builder.Services.AddScoped<SearchService>(); // Arama mantýðý
builder.Services.AddHostedService<DailySearchWorker>(); // Arka plan iþçisi
builder.Services.AddHttpClient<ShopifyService>();
builder.Services.AddHttpClient<ShopifyService>(client =>
{
    client.Timeout = TimeSpan.FromMinutes(5); // 5 dakikaya çýkarýn
});
builder.Services.AddScoped<ILogService, LogService>();
builder.Services.AddScoped<IMailServisi, MailServisi>();
builder.Services.AddTransient<IEmailSender<ApplicationUser>, MailServisi>();
builder.Services.AddScoped<ToastService>();
builder.Services.AddScoped<ISystemService,SystemService>();
var smtpSettings = builder.Configuration.GetSection("SmtpSettings").Get<SmtpSettings>();
builder.Services.AddSingleton(smtpSettings);

builder.Services.Configure<SmtpOtoTicketSettings>(builder.Configuration.GetSection("OtoTicketSettings"));
builder.Services.Configure<MsGraphMailSettings>(builder.Configuration.GetSection("MsGraphMailSettings"));

var projectSettings = builder.Configuration.GetSection("ProjectSettings").Get<ProjectSettings>();
builder.Services.AddSingleton(projectSettings);
builder.Services.Configure<ProjectSettings>(builder.Configuration.GetSection("ProjectSettings"));


builder.Services.AddScoped<UserSessionTracker>(); 
builder.Services.AddScoped<LogService>();

builder.Services.AddServerSideBlazor().AddCircuitOptions(options => { options.DetailedErrors = true; });
builder.Services.AddAntiforgery();
var app = builder.Build();

// 5. HTTP Pipeline Yapýlandýrmasý (Sýralama kritiktir)
if (app.Environment.IsDevelopment())
{
    app.UseWebAssemblyDebugging();
    
        app.UseDeveloperExceptionPage(); // Bu satýr beyaz ekran yerine hatayý görmeni saðlar
        app.UseWebAssemblyDebugging();
    
}
else
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();
// Antiforgery, Authentication'dan önce, Razor Components'dan önce gelmeli
app.UseAntiforgery();


app.UseAuthentication();
app.UseAuthorization();
app.Use(async (context, next) =>
{
    var path = context.Request.Path.Value?.ToLower();

    // 1. ADIM: Statik dosyalarý ve Blazor iç isteklerini (/_blazor) direkt geç
    if (path != null && (path.Contains(".") || path.StartsWith("/_blazor") || path.StartsWith("/_framework")))
    {
        await next();
        return;
    }

    var user = context.User;
    if (user.Identity?.IsAuthenticated == true)
    {
        // 2. ADIM: Ýstisna yollarý (HEPSÝ KÜÇÜK HARF OLMALI)
        var bypassPaths = new[] { "/reset-password", "/account/logout", "/logout", "/account/login" };

        // Eðer kullanýcý bu istisna yollarýndan birindeyse, kontrol etme
        if (bypassPaths.Any(p => path != null && path.StartsWith(p)))
        {
            await next();
            return;
        }

        // 3. ADIM: Þifre Yenileme Kontrolü
        var userManager = context.RequestServices.GetRequiredService<UserManager<ApplicationUser>>();
        var dbUser = await userManager.GetUserAsync(user);

        if (dbUser != null && dbUser.UpdatePassword)
        {
            context.Response.Redirect("/reset-password");
            return;
        }
    }
    await next();
});

// 6. Rota ve Render Mode Ayarlarý
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode()
    .AddInteractiveWebAssemblyRenderMode()
    .AddAdditionalAssemblies(typeof(IbelCodeUrunTakip.Client._Imports).Assembly); // Client projesindeki bileþenleri tanýr

app.MapPost("/Account/Logout", async (
    SignInManager<ApplicationUser> signInManager,
    [FromForm] string returnUrl) =>
{
    await signInManager.SignOutAsync();
    return Results.Redirect(returnUrl ?? "/Account/Login");
}).DisableAntiforgery(); 

using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    // Sadece MigrateAsync kalsýn. 
    // Eðer hala hata alýyorsanýz bu satýrý geçici olarak yorum satýrýna alýp projeyi öyle yayýnlayýn.
    try
    {
        await context.Database.MigrateAsync();
    }
    catch
    {
        // Tablolar zaten varsa hatayý yutmasý için boþ býrakýlabilir
    }
}
app.MapControllers();
app.Run();