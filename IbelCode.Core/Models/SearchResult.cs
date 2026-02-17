using System.ComponentModel.DataAnnotations.Schema;

namespace IbelCode.Core.Models
{
    public class SearchResult
    {
        public int Id { get; set; }

        // Hangi arama işleminin sonucu olduğunu belirten Foreign Key
        public int SearchLogId { get; set; }

        public string ProductTitle { get; set; }
        public string StoreName { get; set; }
        public string Price { get; set; }
        public string Link { get; set; }
        public string Source { get; set; } // Ana Sonuç / Alt Satıcı
        public string PriceRange { get; set; }
        public decimal PriceValue { get; set; } // Fiyatın sayısal değeri

        [ForeignKey("SearchLogId")]
        public virtual SearchLog SearchLog { get; set; }

        // YENİ: Ürün ile ilişki
        public int? ProductId { get; set; }

        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
    }
}
