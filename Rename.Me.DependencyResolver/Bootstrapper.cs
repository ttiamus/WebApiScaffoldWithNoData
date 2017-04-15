using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Rename.Me.Common.Http;
using SimpleInjector;
using SimpleInjector.Diagnostics;
using SimpleInjector.Lifestyles;

namespace Rename.Me.DependencyResolver
{
    public class Bootstrapper
    {
        public static Container GetContainer()
        {
            var container = new Container();
            container.Options.DefaultScopedLifestyle = new AsyncScopedLifestyle();

            container.Register<IHttpHelper, HttpHelper>(Lifestyle.Scoped);
            return container;
        }
    }
}
