using ClosedXML.Excel;
using IbelCode.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Graph.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace IbelCode.Service
{
    public class ShopifyService
    {
        private readonly HttpClient _httpClient;
        private readonly IDbContextFactory<ApplicationDbContext> _dbFactory;


        private string _shopifyUrl;
        private string _accessToken;
        private string _locationId;
        private async Task LoadSettingsFromDbAsync()
        {
            using var context = _dbFactory.CreateDbContext();
            var settings = await context.AppSettings.ToListAsync();

            _shopifyUrl = settings.FirstOrDefault(s => s.SettingKey == "ShopifyUrl")?.SettingValue;

            _accessToken = settings.FirstOrDefault(s => s.SettingKey == "ShopifyAccessToken")?.SettingValue;

            _locationId = settings.FirstOrDefault(s => s.SettingKey == "ShopifyLocationId")?.SettingValue;
        }
        public ShopifyService(HttpClient httpClient, IDbContextFactory<ApplicationDbContext> dbFactory)
        {
            _httpClient = httpClient;
            _dbFactory = dbFactory;

        }

        public async Task<List<ProductNode>> GetProductsAsync()
        {
            await LoadSettingsFromDbAsync();
            var query = new
            {
                query = @"
            {
              products(first: 250) {
                edges {
                  node {
                    id
                    title
                    status
                    variants(first: 10) {
                      edges {
                        node {
                          id
                          title
                          price
                          sku
                          inventoryQuantity
                          inventoryItem { id }
                        }
                      }
                    }
                  }
                }
              }
            }"
            };

            var request = new HttpRequestMessage(HttpMethod.Post, _shopifyUrl);
            request.Headers.Add("X-Shopify-Access-Token", _accessToken);
            request.Content = new StringContent(System.Text.Json.JsonSerializer.Serialize(query), System.Text.Encoding.UTF8, "application/json");

            var response = await _httpClient.SendAsync(request);
            response.EnsureSuccessStatusCode();

            var content = await response.Content.ReadAsStringAsync();
            var result = System.Text.Json.JsonSerializer.Deserialize<ShopifyResponse>(content, new System.Text.Json.JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            return result?.Data?.Products?.Edges?.Select(e => e.Node).ToList() ?? new List<ProductNode>();
        }

        public byte[] ExportProductsToExcel(List<ProductNode> products)
        {
            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("Shopify Güncelleme Listesi");

                // Başlıklar
                worksheet.Cell(1, 1).Value = "Ürün Adı";
                worksheet.Cell(1, 2).Value = "Variant ID";
                worksheet.Cell(1, 3).Value = "SKU";
                worksheet.Cell(1, 4).Value = "Mevcut Fiyat";
                worksheet.Cell(1, 5).Value = "YENİ FİYAT"; // Burayı kullanıcı dolduracak
                worksheet.Cell(1, 6).Value = "Mevcut Stok";
                worksheet.Cell(1, 7).Value = "YENİ STOK"; // Burayı kullanıcı dolduracak
                worksheet.Cell(1, 8).Value = "Product ID"; // Gizli/Gerekli sütun

                // Başlık stilini belirle
                var headerRow = worksheet.Row(1);
                headerRow.Style.Font.Bold = true;
                headerRow.Style.Fill.BackgroundColor = XLColor.LightGray;

                int currentRow = 2;
                foreach (var product in products)
                {
                    foreach (var variantEdge in product.Variants.Edges)
                    {
                        var variant = variantEdge.Node;
                        worksheet.Cell(currentRow, 1).Value = product.Title;
                        worksheet.Cell(currentRow, 2).Value = variant.Id;
                        worksheet.Cell(currentRow, 3).Value = variant.Sku;
                        worksheet.Cell(currentRow, 4).Value = variant.Price;
                        worksheet.Cell(currentRow, 6).Value = variant.InventoryQuantity;
                        worksheet.Cell(currentRow, 8).Value = product.Id;

                        // Sayısal formatları ayarla
                        worksheet.Cell(currentRow, 4).Style.NumberFormat.Format = "#,##0.00";
                        worksheet.Cell(currentRow, 6).Style.NumberFormat.Format = "0";

                        currentRow++;
                    }
                }

                worksheet.Columns().AdjustToContents();
                using var stream = new MemoryStream();
                workbook.SaveAs(stream);
                return stream.ToArray();
            }
        }
        public async Task<(bool Success, string Message)> UpdateVariantPriceAsync(string productId, string variantId, string newPrice, CancellationToken ct = default)
        {
            await LoadSettingsFromDbAsync();
            var mutation = new
            {
                query = @"
        mutation productVariantsBulkUpdate($productId: ID!, $variants: [ProductVariantsBulkInput!]!) {
          productVariantsBulkUpdate(productId: $productId, variants: $variants) {
            productVariants {
              id
              price
            }
            userErrors {
              field
              message
            }
          }
        }",
                variables = new
                {
                    productId = productId, // Ürün ID'si gerekiyor
                    variants = new[]
                    {
                new {
                    id = variantId,
                    price = newPrice.Replace(",", ".")
                }
            }
                }
            };

            var request = new HttpRequestMessage(HttpMethod.Post, _shopifyUrl);
            request.Headers.Add("X-Shopify-Access-Token", _accessToken);
            request.Content = new StringContent(JsonSerializer.Serialize(mutation), Encoding.UTF8, "application/json");

            var response = await _httpClient.SendAsync(request, ct);
            var content = await response.Content.ReadAsStringAsync();

            if (response.IsSuccessStatusCode)
            {
                var jsonResponse = JsonSerializer.Deserialize<JsonElement>(content);
                if (content.Contains("userErrors\":[]"))
                {
                    return (true, "Başarılı");
                }
                else
                {
                    // Shopify içindeki spesifik hata mesajını çekelim
                    var errorMsg = jsonResponse.GetProperty("data")
                                               .GetProperty("productVariantsBulkUpdate")
                                               .GetProperty("userErrors")[0]
                                               .GetProperty("message").GetString();
                    return (false, errorMsg ?? "Bilinmeyen Shopify hatası");
                }
            }
            return (false, "Bağlantı Hatası");
        }

        public async Task<(bool Success, string Message)> UpdateAllVariantsPriceAsync(string productId, List<string> variantIds, string newPrice)
        {
            await LoadSettingsFromDbAsync();
            var variantInputs = variantIds.Select(id => new {
                id = id,
                price = newPrice.Replace(",", ".")
            }).ToArray();

            var mutation = new
            {
                query = @"
        mutation productVariantsBulkUpdate($productId: ID!, $variants: [ProductVariantsBulkInput!]!) {
          productVariantsBulkUpdate(productId: $productId, variants: $variants) {
            productVariants { id price }
            userErrors { field message }
          }
        }",
                variables = new
                {
                    productId = productId,
                    variants = variantInputs
                }
            };

            var request = new HttpRequestMessage(HttpMethod.Post, _shopifyUrl);
            request.Headers.Add("X-Shopify-Access-Token", _accessToken);
            request.Content = new StringContent(JsonSerializer.Serialize(mutation), Encoding.UTF8, "application/json");

            var response = await _httpClient.SendAsync(request);
            var content = await response.Content.ReadAsStringAsync();

            if (response.IsSuccessStatusCode && content.Contains("\"userErrors\":[]"))
                return (true, "Başarılı");

            return (false, "Güncelleme sırasında hata oluştu.");
        }

        public async Task<(bool Success, string Message)> UpdateStockAsync(string inventoryItemId, int newQuantity, CancellationToken ct = default)
        {
            string locationId = "gid://shopify/Location/" + _locationId;
            await LoadSettingsFromDbAsync();
            var mutation = new
            {
                query = @"
        mutation inventorySetQuantities($input: InventorySetQuantitiesInput!) {
          inventorySetQuantities(input: $input) {
            inventoryAdjustmentGroup {
              createdAt
            }
            userErrors {
              field
              message
            }
          }
        }",
                variables = new
                {
                    input = new
                    {
                        name = "available",
                        reason = "correction",
                        // BU SATIRI EKLEDİK: Mevcut stok miktarını kontrol etmeden üzerine yazar
                        ignoreCompareQuantity = true,
                        quantities = new[] {
                    new {
                        inventoryItemId = inventoryItemId,
                        locationId = locationId,
                        quantity = newQuantity
                    }
                }
                    }
                }
            };

            var request = new HttpRequestMessage(HttpMethod.Post, _shopifyUrl);
            request.Headers.Add("X-Shopify-Access-Token", _accessToken);
            request.Content = new StringContent(JsonSerializer.Serialize(mutation), Encoding.UTF8, "application/json");

            var response = await _httpClient.SendAsync(request, ct);
            var content = await response.Content.ReadAsStringAsync();

            if (response.IsSuccessStatusCode && content.Contains("\"userErrors\":[]"))
            {
                return (true, "Başarılı");
            }
            else
            {
                return (false, "Shopify Hatası: " + content);
            }
        }
    }
}
