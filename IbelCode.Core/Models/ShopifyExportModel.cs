namespace IbelCode.Core.Models
{
    public class ShopifyExportModel
    {
        public string ProductTitle { get; set; }
        public string VariantId { get; set; } 
        public string VariantTitle { get; set; }
        public string SKU { get; set; }
        public string CurrentPrice { get; set; }
        public string NewPrice { get; set; } 
        public int Stock { get; set; }
    }

}
