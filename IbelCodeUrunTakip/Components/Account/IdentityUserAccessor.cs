using IbelCode.Core.DTOs;
using IbelCode.Core.Models;
using IbelCode.Data;
using IbelCode.Service;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Server;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using System.Security.Claims;

namespace IbelCodeUrunTakip.Components.Account
{
    internal sealed class IdentityUserAccessor(UserManager<ApplicationUser> userManager, IdentityRedirectManager redirectManager)
    {
        public async Task<ApplicationUser> GetRequiredUserAsync(HttpContext context)
        {
            var user = await userManager.GetUserAsync(context.User);
            if (user is null)
            {
                redirectManager.RedirectToWithStatus("Account/InvalidUser", $"Hata: Kullanıcı yüklenemedi '{userManager.GetUserId(context.User)}'.", context);
            }
            return user;
        }
    }
    internal sealed class IdentityRedirectManager(NavigationManager navigationManager)
    {
        public void RedirectTo(string? uri) => navigationManager.NavigateTo(uri ?? "");

        public void RedirectToWithStatus(string uri, string message, HttpContext context)
        {
            context.Response.Cookies.Append("Identity.StatusMessage", message);
            navigationManager.NavigateTo(uri);
        }
    }
    internal sealed class IdentityRevalidatingAuthenticationStateProvider(
        ILoggerFactory loggerFactory,
        IServiceScopeFactory scopeFactory,
        IOptions<IdentityOptions> options) // Yeni: Oturum bazlı kontrol
    : RevalidatingServerAuthenticationStateProvider(loggerFactory)
    {
        protected override TimeSpan RevalidationInterval => TimeSpan.FromMinutes(30);

        protected override async Task<bool> ValidateAuthenticationStateAsync(
            AuthenticationState authenticationState, CancellationToken cancellationToken)
        {
            await using var scope = scopeFactory.CreateAsyncScope();
            var userManager = scope.ServiceProvider.GetRequiredKeyedService<UserManager<ApplicationUser>>("IbelCodeUserManager"); // Veya standart UserManager
            return await ValidateSecurityStampAsync(userManager, authenticationState.User);
        }

        private async Task<bool> ValidateSecurityStampAsync(UserManager<ApplicationUser> userManager, ClaimsPrincipal principal)
        {
            var user = await userManager.GetUserAsync(principal);
            if (user is null) return false;
            if (!userManager.SupportsUserSecurityStamp) return true;
            var principalStamp = principal.FindFirstValue(options.Value.ClaimsIdentity.SecurityStampClaimType);
            var userStamp = await userManager.GetSecurityStampAsync(user);
            return principalStamp == userStamp;
        }
    }
}
