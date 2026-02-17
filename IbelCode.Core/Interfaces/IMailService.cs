using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IbelCode.Core.Interfaces
{
    public interface IMailServisi
    {
        Task SendEmailAsync(List<string> emails, string subject, string htmlMessage);
        Task SendEmailAsync(string email, string subject, string htmlMessage);
        Task SendEmailWithAttachmentAsync(string toEmail, string subject, string body, byte[]? fileData = null, string? fileName = null);
        Task ReplyToTicketEmailAsync(string originalMessageId, string replyBody, byte[]? fileData = null, string? fileName = null);
    }
}
