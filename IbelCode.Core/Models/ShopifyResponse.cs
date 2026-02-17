using System.Text.Json.Serialization;

public class ShopifyResponse
{
    [JsonPropertyName("data")]
    public Data Data { get; set; }
}

public class Data
{
    [JsonPropertyName("products")]
    public Products Products { get; set; }
}

public class Products
{
    [JsonPropertyName("edges")]
    public List<ProductEdge> Edges { get; set; }
}

public class ProductEdge
{
    [JsonPropertyName("node")]
    public ProductNode Node { get; set; }
}

public class ProductNode
{
    public string Id { get; set; }
    public string Title { get; set; }
    public string Status { get; set; }
    public VariantConnection Variants { get; set; }
    public string? BulkTempPrice { get; set; } // Ürün bazlı toplu fiyat girişi
    public bool IsBulkSaving { get; set; }     // Toplu kayıt animasyonu
    public bool IsUpdated { get; set; }
}

public class VariantConnection
{
    [JsonPropertyName("edges")]
    public List<VariantEdge> Edges { get; set; }
}

public class VariantEdge
{
    [JsonPropertyName("node")]
    public VariantNode Node { get; set; }
}

public class VariantNode
{
    public string Id { get; set; }
    public string Title { get; set; }
    public string Price { get; set; }
    public string Sku { get; set; }
    public int InventoryQuantity { get; set; }
    public string? TempPrice { get; set; }
    public bool IsSaving { get; set; } // Kaydetme animasyonu için
    public InventoryItem inventoryItem { get; set; }
    public string? TempStock { get; set; } // Ekrandan girilen yeni stok
    public bool IsStockSaving { get; set; }

}
public class InventoryItem { public string Id { get; set; } }