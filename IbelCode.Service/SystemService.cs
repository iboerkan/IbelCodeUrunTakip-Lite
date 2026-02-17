using IbelCode.Core.DTOs;
using IbelCode.Core.Interfaces;
using IbelCode.Data;
using Microsoft.EntityFrameworkCore;

namespace IbelCode.Service
{
    public class SystemService : ISystemService
    {
        private readonly IDbContextFactory<ApplicationDbContext> _dbFactory;
        public SystemService(IDbContextFactory<ApplicationDbContext> dbFactory)
        {
            _dbFactory = dbFactory;
         
        }
        public async Task<List<UserDto>> GetUsersAsync()
        {
            using var context = _dbFactory.CreateDbContext();
            return await context.Users
                .Select(u => new UserDto
                {
                    Id = u.Id,
                    UserName = u.UserName,
                     FullName = u.FirstName + " " + u.LastName ,
                     FirstName = u.FirstName,
                        LastName = u.LastName
                }).ToListAsync();
        }
    }
}
