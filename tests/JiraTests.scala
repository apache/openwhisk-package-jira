/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
