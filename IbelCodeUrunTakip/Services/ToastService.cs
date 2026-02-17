using DevExpress.Blazor;

namespace IbelCodeUrunTakip.Services
{
    public class ToastService
    {
        private readonly IToastNotificationService _devExpressToast;

        // DevExpress'in orijinal servisini constructor'da enjekte ediyoruz
        public ToastService(IToastNotificationService devExpressToast)
        {
            _devExpressToast = devExpressToast;
        }

        public async Task Show(string message, ToastRenderStyle style)
        {
            try
            {
                await Task.Delay(100);
                // JS modüllerinin yüklenmesi için Blazor'a milisaniyelik bir nefes veriyoruz
                // Özellikle ilk açılışta 'SafeInvoke' null hatasını engeller
                _devExpressToast.ShowToast(new ToastOptions
                {
                    Text = message,
                    RenderStyle = style,
                    DisplayTime = TimeSpan.FromSeconds(3)
                });
            }
            catch (Exception ex)
            {
                // Eğer hala hata veriyorsa terminalde ne olduğunu görelim
                Console.WriteLine($"Toast Hatası: {ex.Message}");
            }
        }
        public async Task ShowSuccess(string message)
        {
            try
            {
                await Task.Delay(100);
                // JS modüllerinin yüklenmesi için Blazor'a milisaniyelik bir nefes veriyoruz
                // Özellikle ilk açılışta 'SafeInvoke' null hatasını engeller
                _devExpressToast.ShowToast(new ToastOptions
                {
                    Text = message,
                    RenderStyle = ToastRenderStyle.Success,
                    DisplayTime = TimeSpan.FromSeconds(3)
                });
            }
            catch (Exception ex)
            {
                // Eğer hala hata veriyorsa terminalde ne olduğunu görelim
                Console.WriteLine($"Toast Hatası: {ex.Message}");
            }
        }
        public event Action<string> OnShowSuccess;
        public async Task ShowError(string message)
        {
            try
            {
                await Task.Delay(100);
                // JS modüllerinin yüklenmesi için Blazor'a milisaniyelik bir nefes veriyoruz
                // Özellikle ilk açılışta 'SafeInvoke' null hatasını engeller
                _devExpressToast.ShowToast(new ToastOptions
                {
                    Text = message,
                    RenderStyle = ToastRenderStyle.Danger,
                    DisplayTime = TimeSpan.FromSeconds(3)
                });
            }
            catch (Exception ex)
            {
                // Eğer hala hata veriyorsa terminalde ne olduğunu görelim
                Console.WriteLine($"Toast Hatası: {ex.Message}");
            }
        }
    }
}
