using Microsoft.AspNetCore.Identity;

namespace IbelCode.Core.Models
{
    public class ApplicationUser : IdentityUser
    {
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? CompanyName { get; set; }

        public string? Department { get; set; }
        public bool UpdatePassword { get; set; } = false;
        public string? PazarlamaciKodu { get; set; }
        public string? GrupKodu { get; set; }
        public int? BolgeId { get; set; }
    }
}
