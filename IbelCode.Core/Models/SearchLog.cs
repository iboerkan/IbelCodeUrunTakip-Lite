using IbelCode.Core.Models;
using System.ComponentModel.DataAnnotations;

namespace IbelCode.Core.Models
{
    public class SearchLog
    {
        public int Id { get; set; }

        [Required]
        public string UserId { get; set; } // Aramayı yapan kullanıcının ID'si

        public string SearchTerm { get; set; } // Aranan kelime

        public string ExcludedTerms { get; set; } // Hariç tutulanlar

        public string? IncludedTerms { get; set; }

        public DateTime SearchDate { get; set; } = DateTime.Now; // Arama tarihi

        public bool OtomatikSorgula { get; set; } = false;

        // Navigation property (İsteğe bağlı, raporlama için iyi olur)
        public virtual ApplicationUser User { get; set; }
    }
}