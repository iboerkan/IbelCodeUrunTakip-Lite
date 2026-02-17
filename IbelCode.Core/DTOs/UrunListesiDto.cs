using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace IbelCode.Core.DTOs
{
    public class UrunListesiDto
    {
        public int Id { get; set; }
        public string UrunAdi { get; set; }
        public string StokKodu { get; set; }
        public decimal Fiyat { get; set; }
        public int KalanKota { get; set; } // Kota tablosundan gelecek
        public string KategoriAdi { get; set; }
        public int SiparisMiktari { get; set; }
        public decimal KDVOrani { get; set; }
        public int? Ay { get; set; }
        public int? Uretim { get; set; }
        public int? Hedef { get; set; }
        public int? StokAdet { get; set; }
        public int?Satis { get; set; }
        public int? Borc { get; set; }
        public int? STOK_ADET { get; set; }
        public int WebSiraNo { get; set; }
    }
    public class BakiyeSiparislerDto
    {
        public string? STHAR_CARIKOD { get; set; }
        public string? FISNO    { get; set; }
        public string? STOK_KODU { get; set; }
        public string? STOK_ADI { get; set; }
        public decimal? BAKIYE { get; set; }
        public decimal? TUTAR { get; set; }
        public Int16? SUBE_KODU { get; set; }

    }
}
