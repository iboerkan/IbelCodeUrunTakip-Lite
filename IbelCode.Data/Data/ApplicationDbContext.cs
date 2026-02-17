using IbelCode.Core.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System.Reflection.Emit;

namespace IbelCode.Data
{
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

     

        }

        public DbSet<KullaniciLog> KullaniciLogs { get; set; }

        public DbSet<SearchLog> SearchLogs { get; set; }
        public DbSet<SearchResult> SearchResults { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<FilterGroup> FilterGroups { get; set; }
        public DbSet<AppSetting> AppSettings { get; set; }
        public DbSet<ServiceLog> ServiceLogs { get; set; }
        public DbSet<TransferSession> TransferSessions { get; set; }
        public DbSet<TransferLog> TransferLogs { get; set; }
       
    }


}
