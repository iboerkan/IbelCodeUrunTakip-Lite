using IbelCode.Core.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IbelCode.Core.Interfaces
{
    public interface ISystemService
    {
        Task<List<UserDto>> GetUsersAsync();


    }
}
