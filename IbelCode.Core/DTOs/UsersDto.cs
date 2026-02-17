using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IbelCode.Core.DTOs
{
    public class UserDto
    {
        public string Id { get; set; }
        public string UserName { get; set; }
        public string FullName { get; set; } // Varsa Ad Soyad
        public string FirstName { get; set; } // Varsa Ad
        public string LastName { get; set; } // Varsa Soyad
    }
}
