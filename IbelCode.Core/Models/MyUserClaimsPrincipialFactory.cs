using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace IbelCode.Core.Models
{


    public class MyUserClaimsPrincipalFactory : UserClaimsPrincipalFactory<ApplicationUser, IdentityRole>
    {
        public MyUserClaimsPrincipalFactory(
            UserManager<ApplicationUser> userManager,
            RoleManager<IdentityRole> roleManager, // Rol yöneticisini ekledik
            IOptions<IdentityOptions> optionsAccessor)
            : base(userManager, roleManager, optionsAccessor)
        {
        }

        protected override async Task<ClaimsIdentity> GenerateClaimsAsync(ApplicationUser user)
        {
            var identity = await base.GenerateClaimsAsync(user);

            // Kendi özel claim'imizi ekliyoruz
            identity.AddClaim(new Claim("PazarlamaciKodu", user.PazarlamaciKodu ?? ""));
          
            identity.AddClaim(new Claim("BolgeId", (user.BolgeId ?? 0).ToString()));
            identity.AddClaim(new Claim("GrupKodu", user.GrupKodu ?? ""));

            return identity;
        }
    }

}
