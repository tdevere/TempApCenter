using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;
using Windows.UI.Xaml.Media.Imaging;
using Microsoft.AppCenter;
using Microsoft.AppCenter.Analytics;
using Microsoft.AppCenter.Crashes;
// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409

namespace Windows_UWP
{//https://appcenter.ms/orgs/Windows_AppCenter_Samples/apps/Windows_UWP
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        static int TotlClicks = 0;
        static int Count = 0;
        static int Reset = 5;
        static public Guid SessionTracker;
        static Dictionary<int,string> pics = new Dictionary<int,string>();
        static Dictionary<string, string> properties;


        public static class AppCenterProperties
        {
            public static string StartUp { get { return "StartUp"; } }
            public static string Shutdown { get { return "Shutdown"; } }
            public static string Liked { get { return "Liked"; } }
            public static string Error { get { return "Error"; } }
        }

        public MainPage()
        {
            MainPage.SessionTracker = Guid.NewGuid();

            this.InitializeComponent();

            pics.Add(0, "Pictures/CrapeMyrtle.jpg");
            pics.Add(1, "Pictures/CrapeMyrtleByCoup.jpg");
            pics.Add(2, "Pictures/GardenSpider.jpg");
            pics.Add(3, "Pictures/SmallVioletFlower.jpg");
            pics.Add(4, "Pictures/SmallYellowFlower.jpg");
            pics.Add(5, "Pictures/TreeInsect.jpg");

            TrackEvent(AppCenterProperties.StartUp, SessionTracker.ToString(), DateTime.Now.ToLongTimeString());

        }

        private static void TrackEvent(string proptype, string p1, string p2)
        {
            Analytics.TrackEvent(proptype, AddProperty(p1, p2));
        }

        private static Dictionary<string, string> AddProperty(string p1, string p2)
        {
            Dictionary<string, string> properties = new Dictionary<string, string>
            {
                { "SessionTracker", SessionTracker.ToString() },
                { "DateTime", DateTime.Now.ToLongTimeString() }
            };

            properties.Add(p1, p2);

            return properties;
        }

        private void btnMoveNext_Click(object sender, RoutedEventArgs e)
        {
            TotlClicks++;

            try
            {
                string picture = pics[Count];
                this.Background = new ImageBrush { ImageSource = new BitmapImage(new Uri(this.BaseUri, picture)), Stretch = Stretch.UniformToFill };

                if (Count != Reset)
                {
                    Count++;
                }
                else
                {
                    Count = 0;
                    TrackEvent(AppCenterProperties.Liked, SessionTracker.ToString(), TotlClicks.ToString());
                }
            }
            catch(Exception ex)
            {
                Crashes.TrackError(ex, AddProperty(SessionTracker.ToString(), DateTime.Now.ToLongTimeString()));
            }
        }
    }
}
