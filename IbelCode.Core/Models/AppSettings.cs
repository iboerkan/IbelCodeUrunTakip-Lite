using System.ComponentModel.DataAnnotations;

namespace IbelCode.Core.Models
{
    public class AppSetting
    {
        [Key]
        public string SettingKey { get; set; } // Örn: "SerpApiKey"
        public string SettingValue { get; set; }
        public DateTime LastUpdated { get; set; } = DateTime.Now;
    }
}
