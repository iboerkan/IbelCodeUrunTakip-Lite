using System.ComponentModel.DataAnnotations;

namespace IbelCode.Core.Models
{
    public class Product
    {
        public int Id { get; set; }

        [Required]
        public string Title { get; set; } // Ürün Başlığı

        [Required]
        public string StoreName { get; set; } // Mağaza Adı

        public string? Url { get; set; } // Ürün Linki

        // Matematiksel analiz için en güncel fiyat
        public decimal LastPrice { get; set; }

        // Görsel amaçlı en güncel fiyat (₺1.250,00)
        public string? LastPriceString { get; set; }

        public DateTime LastUpdated { get; set; } = DateTime.Now;

        // Geçmiş aramalarla ilişki (Opsiyonel)
        public virtual ICollection<SearchResult> SearchResults { get; set; }
    }
}
