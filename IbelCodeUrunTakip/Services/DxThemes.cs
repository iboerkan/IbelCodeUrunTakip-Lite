using DevExpress.Blazor;

namespace IbelCodeUrunTakip.Services;

public static class DxThemes {
    public static readonly ITheme FluentLight = Themes.Fluent.Clone(AddFluentTheme);
    public static readonly ITheme FluentDark = Themes.Fluent.Clone(properties => {
        properties.Mode = ThemeMode.Dark;
        AddFluentTheme(properties);
    });
    public static readonly ITheme BlazingBerry = Themes.BlazingBerry.Clone(AddBootstrapTheme);
    public static readonly ITheme BlazingDark = Themes.BlazingDark.Clone(AddBootstrapTheme);
    public static readonly ITheme Purple = Themes.Purple.Clone(AddBootstrapTheme);
    public static readonly ITheme OfficeWhite = Themes.OfficeWhite.Clone(AddBootstrapTheme);
    public static readonly ITheme Bootstrap = Themes.BootstrapExternal.Clone(properties => AddBootstrapExternalTheme("bootstrap", properties));
    public static readonly ITheme BootstrapDark = Themes.BootstrapExternal.Clone(properties => AddBootstrapExternalTheme("bootstrap-dark", properties));

    public static void AddBootstrapTheme(ThemeProperties properties) {
        properties.AddFilePaths($"css/theme-bs.css");
    }

    public static void AddBootstrapExternalTheme(string themeName, ThemeProperties properties) {
        properties.Name = themeName;
        AddBootstrapTheme(properties);
        properties.AddFilePaths($"css/bootstrap/bootstrap.min.css");
    }

    public static void AddFluentTheme(ThemeProperties properties) {
        properties.AddFilePaths($"css/theme-fluent.css");
    }
}

public class DxThemesService {
    public DxThemesService() {
        ActiveTheme = DxThemes.Bootstrap;
    }

    public ITheme ActiveTheme { get; private set; }

    public bool IsFluentActive => ActiveTheme == DxThemes.FluentLight || ActiveTheme == DxThemes.FluentDark;

    public bool IsBootstrapDarkActive => ActiveTheme == DxThemes.BootstrapDark;

    public bool IsFluentDarkModeActive => ActiveTheme == DxThemes.FluentDark;

    public bool IsActiveThemeDark => IsBootstrapDarkActive || IsFluentDarkModeActive;
}