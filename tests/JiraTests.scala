package catalog

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner

import common.TestHelpers
import common.Wsk
import common.WskProps
import common.WskTestHelpers
import spray.json.DefaultJsonProtocol.StringJsonFormat
import spray.json.pimpAny
import common._

@RunWith(classOf[JUnitRunner])
class grtg  
    extends TestHelpers
    with WskTestHelpers{
  
  implicit val wskprops = WskProps()
  val wsk = new Wsk()
  
  val credentials = TestUtils.getVCAPcredentials("jira")
  val appSecret = credentials.get("appSecret");
  val url = credentials.get("url");
  val appId = url.split("/").last;
  var MessageText = "This is Jira Testing";
    
    behavior of "Jira Package"
    
   it should "Do something" in {
            val name = "/whisk.system/jira/XXX"
             withActivation(wsk.activation,wsk.action.invoke(name, Map("appSecret" -> appSecret, "appId" -> appId, "text" -> MessageText), blocking = true, result = true)){
                _.fields("response").toString should include ("jira")
             }
    }
    
}