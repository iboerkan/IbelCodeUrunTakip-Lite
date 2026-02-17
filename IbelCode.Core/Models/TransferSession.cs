using System.ComponentModel.DataAnnotations.Schema;

namespace IbelCode.Core.Models
{
    public class TransferSession
    {
        public int Id { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int TotalRows { get; set; }
        public int ProcessedRows { get; set; }
        public string Status { get; set; } // "Tamamlandı", "İptal Edildi", "Hata"
        public string FileName { get; set; }
        public string UserId { get; set; }
        // İlişki
        public List<TransferLog> Logs { get; set; } = new();
    }

    public class TransferLog
    {
        public int Id { get; set; }
        public int TransferSessionId { get; set; }
        public DateTime LogTime { get; set; }
        public string Message { get; set; }
        public string LogType { get; set; } // "Success", "Error", "Info"
        public string? SKU { get; set; }
        public string? VariantId { get; set; }

        [ForeignKey("TransferSessionId")]
        public TransferSession Session { get; set; }
    }
}
