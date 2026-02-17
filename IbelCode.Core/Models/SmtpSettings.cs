namespace IbelCode.Core.Models
{
    public class SmtpSettings
    {
        public string Server { get; set; }
        public int Port { get; set; }
        public string SenderName { get; set; }
        public string SenderEmail { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public bool EnableSSL { get; set; }
        public int CheckIntervalMinutes { get; set; }

      
    }
    public class SmtpOtoTicketSettings
    {
        public string Server { get; set; }
        public int Port { get; set; }
        public string SenderName { get; set; }
        public string SenderEmail { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public bool EnableSSL { get; set; }
        public int CheckIntervalMinutes { get; set; }

      
    }
    public class MsGraphMailSettings
    {

        public string TenantId { get; set; }
        public string ClientId { get; set; }
        public string ClientSecret { get; set; }
        public string TargetEmail { get; set; }
    }



}
