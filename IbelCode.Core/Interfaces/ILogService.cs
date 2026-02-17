using IbelCode.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IbelCode.Core.Interfaces
{
    public interface ILogService
    {
        Task<int> CreateSessionAsync(string fileName, int totalRows, string userId);
        Task UpdateSessionStatusAsync(int sessionId, string status, int processedRows, int totalRows = 0);
        Task AddLogAsync(int sessionId, string message, string type, string? sku = null, string? variantId = null);
        Task<List<TransferSession>> GetSessionsAsync(DateTime? startDate = null, DateTime? endDate = null);
        Task<List<TransferLog>> GetLogsBySessionIdAsync(int sessionId);
    }
}
