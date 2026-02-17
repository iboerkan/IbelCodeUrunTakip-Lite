using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IbelCode.Core.DTOs
{
    public class TempFileModel
    {
        public string FileName { get; set; }
        public string PreviewUrl { get; set; }
        public bool IsImage { get; set; }
        public string Base64Content { get; set; }
    }
}
