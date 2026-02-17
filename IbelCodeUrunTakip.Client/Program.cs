using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.Services.AddDevExpressBlazor(options => {
    options.SizeMode = DevExpress.Blazor.SizeMode.Medium;
});
await builder.Build().RunAsync();