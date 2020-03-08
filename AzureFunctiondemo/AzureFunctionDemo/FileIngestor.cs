using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.WindowsAzure.Storage.Blob;

namespace AzureFunctionDemo
{
    public static class FileIngestor
    {
        [FunctionName("IngestFile")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            [Blob("purchaseorder", FileAccess.Write, Connection = "StorageConnectionString")] CloudBlobContainer outputContainer,
            ILogger log)
        {
            log.LogInformation("IngestFile triggered");

            var requestBody = await new StreamReader(req.Body).ReadToEndAsync();

            if (requestBody.Length > 0)
            {
                var blobName = Guid.NewGuid().ToString();
                await outputContainer.CreateIfNotExistsAsync();

                var cloudBlockBlob = outputContainer.GetBlockBlobReference(blobName);
                await cloudBlockBlob.UploadTextAsync(requestBody);

                return new OkObjectResult(blobName);
            }
            return new BadRequestObjectResult("Request body empty");
        }
    }
}
