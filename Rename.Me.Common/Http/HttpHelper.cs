using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace Rename.Me.Common.Http
{
    public class HttpHelper : IHttpHelper
    {
        private static HttpClient http = new HttpClient();

        public HttpHelper()
        {
            //Add any default http configuration here. For example add auth headers
        }
        public Task<HttpResponseMessage> GetAsync(string url, Dictionary<string, string> parameters = null)
        {
            var finalUrl = BuildGetUrl(url, parameters);
            return http.GetAsync(finalUrl);
        }

        public HttpResponseMessage Get(string url, Dictionary<string, string> parameters = null)
        {
            return GetAsync(url, parameters).Result;
        }

        private string BuildGetUrl(string url, Dictionary<string, string> parameters)
        {
            var queryString = "";

            foreach (var param in parameters)
            {
                queryString = $"{queryString}{param.Key}={param.Value}&";
            }

            if (!url.Contains("?")) //Add questionmark to end of url if not provided
                url = url + "?";

            return url + queryString;
        }

        public HttpResponseMessage Post(string url, Dictionary<string, object> parameters)
        {
            return PostAsync(url, parameters).Result;
        }

        public Task<HttpResponseMessage> PostAsync(string url, Dictionary<string, object> parameters)
        {
            var paramList = new List<KeyValuePair<string, string>>();

            if (parameters != null)
            {

                foreach (var parameter in parameters)
                {
                    paramList.Add(new KeyValuePair<string, string>(parameter.Key, JsonConvert.SerializeObject(parameter.Value)));
                }
            }

            return http.PostAsync(url, new FormUrlEncodedContent(paramList));
        }
    }
}
