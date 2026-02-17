namespace IbelCode.Core.Models
{
    public class FilterGroup
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public string GroupName { get; set; } // Örn: "Bisiklet Filtresi"
        public string ExcludedTerms { get; set; }
        public string IncludedTerms { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;
    }
}
