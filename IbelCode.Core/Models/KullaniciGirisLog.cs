using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IbelCode.Core.Models
{
    public class KullaniciLog
    {
        public int Id { get; set; }
        public string KullaniciAdi { get; set; }
        public DateTime GirisTarihi { get; set; } = DateTime.Now;
        public string IpAdresi { get; set; }
        public string TarayiciBilgisi { get; set; } // Hangi tarayıcıdan girdi?
    }
}
