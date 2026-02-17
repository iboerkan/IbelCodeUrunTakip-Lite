using Azure.Identity;
using IbelCode.Core.Models;
using IbelCode.Core.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.Graph;
using Microsoft.Graph.Models;
using System.Net;
using System.Net.Mail;
namespace IbelCode.Service
{
    public class MailServisi : IMailServisi, IEmailSender<ApplicationUser>
    {
        private readonly SmtpSettings _settings;
        private readonly ProjectSettings _configuration;
        private readonly MsGraphMailSettings _graphSettings;
        public MailServisi(SmtpSettings settings, ProjectSettings configuration, IOptions<MsGraphMailSettings> graphSettings)
        {
            _settings = settings;
            _configuration = configuration;
            _graphSettings = graphSettings.Value;
        }

        // Diğer metodları (Şifre sıfırlama vb.) şimdilik boş bırakabilirsin
        public async Task SendPasswordResetLinkAsync(ApplicationUser? user, string email, string confirmationLink)
        {
            var client = new SmtpClient(_settings.Server, _settings.Port)
            {
                EnableSsl = true,
                Credentials = new NetworkCredential(_settings.Username, _settings.Password)
            };

            var mailMessage = new MailMessage(_settings.Username, email)
            {
                Subject = "Şifrenizi Sıfırlayın",
                Body = $"Lütfen şifrenizi sıfırlamak için <a href='{confirmationLink}'>buraya tıklayın</a>.",
                IsBodyHtml = true
            };

            await client.SendMailAsync(mailMessage);
        }
        public Task SendPasswordResetCodeAsync(ApplicationUser user, string email, string resetCode) => Task.CompletedTask;

        public async Task SendEmailAsync(string email, string subject, string htmlMessage)
        {
            if (_configuration.OtoTicketSistemi == "Graph")
            {
                try
                {
                    await SendEmailWithGraphAsync(email, subject, htmlMessage);
                    return;
                }
                catch (Exception ex)
                {
                    throw new Exception($"Graph API ile mail gönderilemedi: {ex.Message}");
                }

            }
            else
            {
                try
                {
                    // Appsettings.json dosyanızdan bilgileri çeker
                    var host = _settings.Server;
                    var port = Convert.ToInt32(_settings.Port);
                    var fromEmail = _settings.Username;
                    var password = _settings.Password;

                    var client = new SmtpClient(host, port)
                    {
                        Credentials = new NetworkCredential(fromEmail, password),
                        EnableSsl = true
                    };

                    var mailMessage = new MailMessage
                    {
                        From = new MailAddress(_settings.SenderEmail, _configuration.Title),
                        Subject = subject,
                        Body = htmlMessage,
                        IsBodyHtml = true
                    };
                    mailMessage.To.Add(email);

                    await client.SendMailAsync(mailMessage);
                    return;
                }
                catch (Exception ex)
                {

                    throw new Exception($"Mail gönderilemedi: {ex.Message}");
                }

            }

        }

        public async Task SendEmailAsync(List<string> emails, string subject, string htmlMessage)
        {
            if (_configuration.OtoTicketSistemi == "Graph")
            {
                try
                {
                    await SendEmailWithGraphAsync(emails, subject, htmlMessage);
                    return;
                }
                catch (Exception ex)
                {
                    throw new Exception($"Graph API ile mail gönderilemedi: {ex.Message}");
                }

            }
            else
            {
                try
                {
                    // Appsettings.json dosyanızdan bilgileri çeker
                    var host = _settings.Server;
                    var port = Convert.ToInt32(_settings.Port);
                    var fromEmail = _settings.Username;
                    var password = _settings.Password;

                    var client = new SmtpClient(host, port)
                    {
                        Credentials = new NetworkCredential(fromEmail, password),
                        EnableSsl = true
                    };

                    var mailMessage = new MailMessage
                    {
                        From = new MailAddress(_settings.SenderEmail, _configuration.Title),
                        Subject = subject,
                        Body = htmlMessage,
                        IsBodyHtml = true
                    };
                    foreach (var email in emails)
                        mailMessage.To.Add(email);

                    await client.SendMailAsync(mailMessage);
                    return;
                }
                catch (Exception ex)
                {

                    throw new Exception($"Mail gönderilemedi: {ex.Message}");
                }

            }

        }

        public async Task SendEmailWithGraphAsync(string email, string subject, string htmlMessage)
        {
            // 1. Kimlik Bilgilerini Hazırla (appsettings'den çektiğiniz bilgiler)
            var tenantId = _graphSettings.TenantId;
            var clientId = _graphSettings.ClientId;
            var clientSecret = _graphSettings.ClientSecret;
            var senderEmail = _graphSettings.TargetEmail; // Gönderen mail adresi

            var credential = new ClientSecretCredential(tenantId, clientId, clientSecret);
            var graphClient = new GraphServiceClient(credential);

            // 2. Mesaj Yapısını Oluştur
            var requestBody = new Microsoft.Graph.Users.Item.SendMail.SendMailPostRequestBody
            {
                Message = new Message
                {

                    Subject = subject,
                    Body = new ItemBody
                    {
                        ContentType = BodyType.Html,
                        Content = htmlMessage
                    },
                    From = new Recipient
                    {
                        EmailAddress = new EmailAddress
                        {
                            Name = _configuration.Title, // ProjectSettings'den gelen Title
                            Address = senderEmail
                        }
                    },
                    Sender = new Recipient
                    {
                        EmailAddress = new EmailAddress
                        {
                            Name = _configuration.Title,
                            Address = senderEmail
                        }
                    },
                    ToRecipients = new List<Recipient>
            {
                new Recipient
                {
                    EmailAddress = new EmailAddress
                    {
                        Address = email
                    }
                }
            }
                },
                SaveToSentItems = true // Gönderilenler klasörüne kaydet
            };

            // 3. Maili Gönder
            await graphClient.Users[senderEmail].SendMail.PostAsync(requestBody);
        }
        public async Task SendEmailWithGraphAsync(List<string> toEmails, string subject, string htmlMessage)
        {
            var tenantId = _graphSettings.TenantId;
            var clientId = _graphSettings.ClientId;
            var clientSecret = _graphSettings.ClientSecret;
            var senderEmail = _graphSettings.TargetEmail;

            var credential = new ClientSecretCredential(tenantId, clientId, clientSecret);
            var graphClient = new GraphServiceClient(credential);

            // 1. Alıcı listesini Microsoft Graph Recipient listesine dönüştür (LINQ ile)
            var recipients = toEmails.Select(email => new Recipient
            {
                EmailAddress = new EmailAddress
                {
                    Address = email.Trim()
                }
            }).ToList();

            // 2. Mesaj Yapısını Oluştur
            var requestBody = new Microsoft.Graph.Users.Item.SendMail.SendMailPostRequestBody
            {
                Message = new Message
                {
                    Subject = subject,
                    Body = new ItemBody
                    {
                        ContentType = BodyType.Html,
                        Content = htmlMessage
                    },
                    From = new Recipient
                    {
                        EmailAddress = new EmailAddress
                        {
                            Name = _configuration.Title,
                            Address = senderEmail
                        }
                    },
                    // 3. Çoklu alıcı listesini buraya ata
                    ToRecipients = recipients
                },
                SaveToSentItems = true
            };

            await graphClient.Users[senderEmail].SendMail.PostAsync(requestBody);
        }
        public async Task SendConfirmationLinkAsync(ApplicationUser? user, string email, string confirmationLink)
        {
            var client = new SmtpClient(_settings.Server, _settings.Port)
            {
                EnableSsl = true,
                Credentials = new NetworkCredential(_settings.SenderEmail, _settings.Password)
            };

            var mailMessage = new MailMessage(_settings.Username, email)
            {
                Subject = "Hesabınızı Onaylayın",
                Body = $"Lütfen üyeliğinizi tamamlamak için <a href='{confirmationLink}'>buraya tıklayın</a>.",
                IsBodyHtml = true
            };

            await client.SendMailAsync(mailMessage);
        }

        public async Task SendEmailWithAttachmentAsync(string toEmail, string subject, string body, byte[]? fileData = null, string? fileName = null)
        { // 1. Kimlik Bilgilerini Hazırla (appsettings'den çektiğiniz bilgiler)
            var tenantId = _graphSettings.TenantId;
            var clientId = _graphSettings.ClientId;
            var clientSecret = _graphSettings.ClientSecret;
            var senderEmail = _graphSettings.TargetEmail; // Gönderen mail adresi

            var credential = new ClientSecretCredential(tenantId, clientId, clientSecret);
            var graphClient = new GraphServiceClient(credential);
            var message = new Microsoft.Graph.Models.Message
            {
                Subject = subject,
                Body = new Microsoft.Graph.Models.ItemBody
                {
                    ContentType = Microsoft.Graph.Models.BodyType.Html,
                    Content = body
                },
                From = new Recipient
                {
                    EmailAddress = new EmailAddress
                    {
                        Name = _configuration.Title, // ProjectSettings'den gelen Title
                        Address = senderEmail
                    }
                },
                Sender = new Recipient
                {
                    EmailAddress = new EmailAddress
                    {
                        Name = _configuration.Title,
                        Address = senderEmail
                    }
                },
                ToRecipients = new List<Microsoft.Graph.Models.Recipient>
        {
            new Microsoft.Graph.Models.Recipient { EmailAddress = new Microsoft.Graph.Models.EmailAddress { Address = toEmail } }
        }
            };

            // EĞER DOSYA VARSA EKLE
            if (fileData != null && !string.IsNullOrEmpty(fileName))
            {
                message.Attachments = new List<Microsoft.Graph.Models.Attachment>
        {
            new Microsoft.Graph.Models.FileAttachment
            {
                Name = fileName,
                ContentBytes = fileData, // Graph SDK bunu otomatik Base64 yapar
                ContentType = "application/octet-stream"
            }
        };
            }

            await graphClient.Users[senderEmail]
                .SendMail
                .PostAsync(new Microsoft.Graph.Users.Item.SendMail.SendMailPostRequestBody { Message = message });
        }
        public async Task ReplyToTicketEmailAsync(string conversationId, string replyText, byte[]? fileData = null, string? fileName = null)
        {
            var senderEmail = _graphSettings.TargetEmail;
            var credential = new ClientSecretCredential(_graphSettings.TenantId, _graphSettings.ClientId, _graphSettings.ClientSecret);
            var graphClient = new GraphServiceClient(credential);

            try
            {
                // 1. Konuşma ID'sini kullanarak en son mesajın gerçek ID'sini (AAMk...) buluyoruz
                var messagesResponse = await graphClient.Users[senderEmail].Messages
                    .GetAsync(config =>
                    {
                        config.QueryParameters.Filter = $"conversationId eq '{conversationId}'";
                        config.QueryParameters.Top = 1;
                        config.QueryParameters.Select = new[] { "id" };
                    });

                var lastMessageId = messagesResponse?.Value?.FirstOrDefault()?.Id;
                if (string.IsNullOrEmpty(lastMessageId)) return;

                // 2. Doğal Yanıt Taslağı oluştur (Bu işlem alıcıları ve konuyu otomatik hazırlar)
                var draft = await graphClient.Users[senderEmail]
                    .Messages[lastMessageId]
                    .CreateReply
                    .PostAsync(new Microsoft.Graph.Users.Item.Messages.Item.CreateReply.CreateReplyPostRequestBody());

                if (draft?.Id == null) return;

                // 3. Sadece mesaj içeriğini ve varsa dosyayı taslağa ekle (Patch)
                // DİKKAT: Burada Subject, ToRecipients veya ConversationId set etmiyoruz (Hata vermemesi için)
                var patchMessage = new Microsoft.Graph.Models.Message
                {
                    Body = new Microsoft.Graph.Models.ItemBody
                    {
                        ContentType = Microsoft.Graph.Models.BodyType.Html,
                        Content = replyText + "<br/><br/>" + (draft.Body?.Content ?? "")
                    }
                };

                if (fileData != null && !string.IsNullOrEmpty(fileName))
                {
                    patchMessage.Attachments = new List<Microsoft.Graph.Models.Attachment>
            {
                new Microsoft.Graph.Models.FileAttachment
                {
                    OdataType = "#microsoft.graph.fileAttachment",
                    Name = fileName,
                    ContentBytes = fileData,
                    ContentType = "application/octet-stream"
                }
            };
                }

                // Taslağı güncelle
                await graphClient.Users[senderEmail].Messages[draft.Id].PatchAsync(patchMessage);

                // 4. Taslağı gönder
                await graphClient.Users[senderEmail].Messages[draft.Id].Send.PostAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Yanıt gönderme hatası: {ex.Message}");
            }
        }
    }
}
