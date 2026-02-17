using System.ComponentModel.DataAnnotations;

namespace IbelCode.Core.Models
{
    public class ServiceLog
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string ServiceName { get; set; } // Örn: "DailySearchWorker"

        public DateTime LastRunDate { get; set; } = DateTime.Now;

        public string Status { get; set; } // Örn: "Başarılı", "Hata", "Çalışıyor"

        public string? Message { get; set; } // Örn: "15 ürün güncellendi" veya Hata Mesajı
    }

}
