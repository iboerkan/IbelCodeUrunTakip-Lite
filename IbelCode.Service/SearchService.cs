using IbelCode.Core.Models;
using IbelCode.Data;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace IbelCode.Service
{
    public class SearchService
    {
        private readonly IDbContextFactory<ApplicationDbContext> _dbFactory;

        private readonly HttpClient _http;

        public SearchService(IDbContextFactory<ApplicationDbContext> dbFactory, HttpClient http)
        {
            _dbFactory = dbFactory;
            _http = http;
        }

        public async Task UpdateAllLoggedSearches()
        {
            using var context = await _dbFactory.CreateDbContextAsync();

            // SADECE OtomatikSorgula aktif olan ve son 30 günde aranmış kayıtları alalım
            var uniqueSearches = await context.SearchLogs
                .Where(x => x.OtomatikSorgula == true && x.SearchDate >= DateTime.Now.AddDays(-30))
                .GroupBy(x => new { x.SearchTerm, x.ExcludedTerms, x.IncludedTerms })
                .Select(g => g.First())
                .ToListAsync();

            var serviceLog = new ServiceLog
            {
                ServiceName = "DailySearchWorker",
                Status = "Çalışıyor",
                Message = $"{uniqueSearches.Count} adet otomatik takip ürünü bulundu. İşlem başlıyor..."
            };
            context.ServiceLogs.Add(serviceLog);
            await context.SaveChangesAsync();

            int toplamGuncellenen = 0;

            try
            {
                foreach (var search in uniqueSearches)
                {
                    try
                    {

                        var tarananSonuclar = await TumUrunleriVeAltSaticilariListele(search.SearchTerm, search.ExcludedTerms, search.IncludedTerms);


                        if (tarananSonuclar != null && tarananSonuclar.Any())
                        {
                            await SaveSearchAndResultsToDatabase(search.SearchTerm, search.ExcludedTerms, search.IncludedTerms, tarananSonuclar, search.UserId);
                            toplamGuncellenen++;
                        }

                        await Task.Delay(1000);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Arama hatası ({search.SearchTerm}): {ex.Message}");
                    }
                }

                serviceLog.Status = "Başarılı";
                serviceLog.Message = $"{toplamGuncellenen} arama grubu ve ilgili ürünleri güncellendi.";
            }
            catch (Exception ex)
            {
                serviceLog.Status = "Hata";
                serviceLog.Message = ex.Message;
            }
            finally
            {
                await context.SaveChangesAsync();
            }
        }

        private async Task<string> GetSerpApiKey()
        {
            using var context = await _dbFactory.CreateDbContextAsync();
            var setting = await context.AppSettings.FirstOrDefaultAsync(s => s.SettingKey == "SerpApiKey");
            return setting?.SettingValue ?? "";
        }

        public async Task<List<SaticiDetayModel>> TumUrunleriVeAltSaticilariListele(string arananUrun, string haricTutulanlar, string dahilEdilenler)
        {
            var sonuclar = new List<SaticiDetayModel>();
            string apiKey = await GetSerpApiKey();

            if (string.IsNullOrEmpty(apiKey)) return sonuclar;

            var excludeTags = string.IsNullOrEmpty(haricTutulanlar)
                ? new List<string>()
                : haricTutulanlar.Split(',').Select(x => x.Trim().ToUpper()).ToList();

            var includeTags = string.IsNullOrEmpty(dahilEdilenler)
                ? new List<string>()
                : dahilEdilenler.Split(',').Select(x => x.Trim().ToUpper()).ToList();

            string searchUrl = $"https://serpapi.com/search.json?engine=google_shopping&q={Uri.EscapeDataString(arananUrun)}&api_key={apiKey}&gl=tr&hl=tr";

            try
            {
                var response = await _http.GetStringAsync(searchUrl);
                var searchData = JObject.Parse(response);
                var mainResults = searchData["shopping_results"] as JArray;

                if (mainResults == null) return sonuclar;

                foreach (var item in mainResults)
                {
                    string urunBasligi = item["title"]?.ToString();
                    string immersiveToken = item["immersive_product_page_token"]?.ToString();

                    if (!string.IsNullOrEmpty(immersiveToken))
                    {
                        string detailUrl = $"https://serpapi.com/search.json?engine=google_immersive_product&page_token={immersiveToken}&api_key={apiKey}&gl=tr&hl=tr";
                        var detailRes = await _http.GetStringAsync(detailUrl);
                        var detailData = JObject.Parse(detailRes);
                        var productResults = detailData["product_results"];
                        var sellers = productResults?["stores"] as JArray;

                        if (sellers != null)
                        {
                            foreach (var s in sellers)
                            {
                                string saticiUrunBasligi = s["title"]?.ToString() ?? "";
                                string saticiUrunBasligiUpper = saticiUrunBasligi.ToUpper();

                                bool satisfiesExclude = !excludeTags.Any(t => saticiUrunBasligiUpper.Contains(t));
                                bool satisfiesInclude = includeTags.Count == 0 || includeTags.Any(t => saticiUrunBasligiUpper.Contains(t));

                                if (satisfiesExclude && satisfiesInclude)
                                {
                                    sonuclar.Add(new SaticiDetayModel
                                    {
                                        OrtalamTutar = productResults["price_range"]?.ToString(),
                                        AnaUrunAdi = urunBasligi,
                                        SaticiAdi = s["name"]?.ToString(),
                                        Fiyat = s["price"]?.ToString(),
                                        Link = s["link"]?.ToString(),
                                        Kaynak = "Alt Satıcı"
                                    });
                                }
                            }
                        }
                    }
                    else
                    {
                        string titleUpper = urunBasligi?.ToUpper() ?? "";
                        bool satisfiesExclude = !excludeTags.Any(t => titleUpper.Contains(t));
                        bool satisfiesInclude = includeTags.Count == 0 || includeTags.Any(t => titleUpper.Contains(t));

                        if (satisfiesExclude && satisfiesInclude)
                        {
                            sonuclar.Add(new SaticiDetayModel
                            {
                                AnaUrunAdi = urunBasligi,
                                SaticiAdi = item["source"]?.ToString(),
                                Fiyat = item["price"]?.ToString(),
                                Link = item["link"]?.ToString(),
                                Kaynak = "Ana Sonuç"
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"API Hatası: {ex.Message}");
            }

            return sonuclar.OrderBy(q => q.AnaUrunAdi).ToList();
        }

        private async Task SaveSearchAndResultsToDatabase(string search, string exclude, string dahil, List<SaticiDetayModel> results, string userId)
        {
            if (string.IsNullOrEmpty(userId)) return;

            using var context = _dbFactory.CreateDbContext();


            var log = new SearchLog
            {
                UserId = userId,
                SearchTerm = search,
                ExcludedTerms = exclude,
                IncludedTerms = dahil,
                SearchDate = DateTime.Now,
                OtomatikSorgula = true
                ,
            };
            context.SearchLogs.Add(log);
            await context.SaveChangesAsync();


            foreach (var r in results)
            {
                decimal currentPrice = ParsePriceToDecimal(r.Fiyat);
                string rTitle = r.AnaUrunAdi?.Trim() ?? "Bilinmeyen Ürün";
                string rStore = r.SaticiAdi?.Trim() ?? "Bilinmeyen Mağaza";

                var existingProduct = await context.Products.FirstOrDefaultAsync(p =>
                    p.Title == rTitle && p.StoreName == rStore);

                if (existingProduct != null)
                {
                    existingProduct.LastPrice = currentPrice;
                    existingProduct.LastPriceString = r.Fiyat;
                    existingProduct.LastUpdated = DateTime.Now;
                    existingProduct.Url = r.Link;
                }
                else
                {
                    existingProduct = new Product
                    {
                        Title = rTitle,
                        StoreName = rStore,
                        Url = r.Link,
                        LastPrice = currentPrice,
                        LastPriceString = r.Fiyat,
                        LastUpdated = DateTime.Now
                    };
                    context.Products.Add(existingProduct);
                }

                var searchResult = new SearchResult
                {
                    SearchLogId = log.Id,
                    Product = existingProduct,
                    ProductTitle = rTitle,
                    StoreName = rStore,
                    Price = r.Fiyat ?? "0",
                    PriceValue = currentPrice,
                    Link = r.Link,
                    Source = r.Kaynak ?? "Genel",
                    PriceRange = r.OrtalamTutar ?? ""
                };
                context.SearchResults.Add(searchResult);
            }

            await context.SaveChangesAsync();
        }

        public decimal ParsePriceToDecimal(string priceText)
        {
            if (string.IsNullOrWhiteSpace(priceText)) return 0;
            try
            {
                string cleanPrice = new string(priceText.Where(c => char.IsDigit(c) || c == ',' || c == '.').ToArray());
                if (cleanPrice.Contains(",") && cleanPrice.Contains("."))
                    cleanPrice = cleanPrice.Replace(".", "").Replace(",", ".");
                else if (cleanPrice.Contains(","))
                    cleanPrice = cleanPrice.Replace(",", ".");

                return decimal.TryParse(cleanPrice, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal result) ? result : 0;
            }
            catch { return 0; }
        }
    }
    public class SaticiDetayModel
    {
        public string AnaUrunAdi { get; set; }
        public string SaticiAdi { get; set; }
        public string Fiyat { get; set; }
        public string Link { get; set; }
        public string Kaynak { get; set; }
        public string OrtalamTutar { get; set; }
    }
}
