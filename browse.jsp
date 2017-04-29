<%@page import="java.sql.*,
                javax.sql.*,
                java.io.IOException"
%>
<%

    //Get session attributes
    String customerId = (String) session.getAttribute("customerId");
    String customerFirstName = (String) session.getAttribute("customerFirstName");
    String customerLastName = (String) session.getAttribute("customerLastName");
    String loggedIn = (String) session.getAttribute("loggedIn");

    //Check to see if the user has logged in. If not, redirect user to the login page.
    if (loggedIn == null) {
        out.println("<script> window.location.replace('index.html'); </script>");
    }

%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/mal.css">
    <script type="text/javascript" async=""
            src="https://www.gstatic.com/recaptcha/api2/r20170411114922/recaptcha__en.js"></script>
    <script async="" type="text/javascript" src="https://www.googletagservices.com/tag/js/gpt.js"></script>
    <script type="text/javascript"
            src="https://myanimelist.cdn-dena.com/static/assets/js/pc/header-61a5e90384.js"></script>
</head>

<body onload=" " class="page-common">
<div id="myanimelist">
    <div class="_unit " style="width:1px;display: block !important;" data-height="1">
        <div id="skin_detail" class="" style="width:1px;">
            <script type="text/javascript">
                googletag.cmd.push(function () {
                    var slot = googletag.defineOutOfPageSlot("/84947469/skin_detail", "skin_detail").addService(googletag.pubads())
                        .setTargeting("adult", "white").setCollapseEmptyDiv(true, true);
                    googletag.enableServices();

                    googletag.display("skin_detail");
                });</script>
        </div>
    </div>

    <div class="wrapper">
        <div id="headerSmall">
            <a href="/" class="">Fabflix</a>
        </div>
        <div id="menu" class="">
            <div id="menu_left">
                <ul id="nav">
                    <li class="small">
                        <a href="search.jsp" class="non-link">Search</a>
                    </li>
                    <li class="small">
                        <a href="browse.jsp" class="non-link">Browse</a>
                    </li>
                </ul>
            </div>
        </div>
        <div id="contentWrapper" itemscope="" itemtype="http://schema.org/Product">
            <div><h1 class="h1">Browse Movies</h1></div>
            <div id="content">

                <div id="horiznav_nav" class="ac mt8 ml0 mr0">
                </div>

                <div>
                    <form id="advancedsearch" data-type="anime" method="GET" action="https://myanimelist.net/anime.php"
                          class="js-advancedsearch">
                        <div class="anime-search-form-block po-r">
                            <div class="anime-search-form-search clearfix mb8"><input id="q" name="q" size="50"
                                                                                      type="text" autocomplete="off"
                                                                                      placeholder="Search Anime..."
                                                                                      class="inputtext js-advancedSearchText">
                                <input type="submit" value="" class="inputButton notActive"></div>
                            <a href="javascript:void(0);" onclick="search_showAdvanced();" class="fl-r fs12"><i
                                    class="fa fa-plus-square-o mr4"></i>Advanced Search</a>
                            <div id="advancedSearchResultList" class="incrementalSearchResultList"
                                 style="left: 0px; top: 50px; width: 716px; display: none;">
                                <div class="list list-bottom focus" style="display: none;"><a
                                        href="/anime.php?q=&amp;type=0&amp;score=0&amp;status=0&amp;p=0&amp;r=0&amp;sm=0&amp;sd=0&amp;sy=0&amp;em=0&amp;ed=0&amp;ey=0&amp;c%5B%5D=a&amp;c%5B%5D=b&amp;c%5B%5D=c&amp;c%5B%5D=f&amp;gx=0">
                                    View all results for <span class="fw-b"></span> <i class="fa fa-spinner fa-spin"
                                                                                       style="display: none;"></i></a>
                                </div>
                            </div>
                        </div>
                        <div id="advancedSearch" style="display: none;">
                            <div class="normal_header pt24 mt16 mb0">Filters</div>
                            <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                <tbody>
                                <tr>
                                    <td width="100">Type</td>
                                    <td><select name="type" id="filterByType" class="inputtext">
                                        <option selected="selected" value="0">Select type</option>
                                        <option value="1">TV</option>
                                        <option value="2">OVA</option>
                                        <option value="3">movies.Movie</option>
                                        <option value="4">Special</option>
                                        <option value="5">ONA</option>
                                        <option value="6">Music</option>
                                    </select></td>
                                </tr>
                                <tr>
                                    <td>Score</td>
                                    <td><select name="score" id="score" class="inputtext">
                                        <option selected="selected" value="0">Select score</option>
                                        <option value="10">(10) Masterpiece</option>
                                        <option value="9">(9) Great</option>
                                        <option value="8">(8) Very Good</option>
                                        <option value="7">(7) Good</option>
                                        <option value="6">(6) Fine</option>
                                        <option value="5">(5) Average</option>
                                        <option value="4">(4) Bad</option>
                                        <option value="3">(3) Very Bad</option>
                                        <option value="2">(2) Horrible</option>
                                        <option value="1">(1) Appalling</option>
                                    </select></td>
                                </tr>
                                <tr>
                                    <td>Status</td>
                                    <td><select name="status" id="status" class="inputtext">
                                        <option selected="selected" value="0">Select status</option>
                                        <option value="2">Finished Airing</option>
                                        <option value="1">Currently Airing</option>
                                        <option value="3">Not yet aired</option>
                                    </select></td>
                                </tr>
                                <tr>
                                    <td>Producer</td>
                                    <td><select name="p" id="p" class="inputtext">
                                        <option selected="selected" value="0">Select producer</option>
                                        <option value="1286">10Gauge</option>
                                        <option value="713">12 Diary Holders</option>
                                        <option value="1117">1st PLACE</option>
                                        <option value="1079">3xCube</option>
                                        <option value="252">4Kids Entertainment</option>
                                        <option value="691">501st JOINT FIGHTER WING</option>
                                        <option value="1425">5pb.</option>
                                        <option value="1185">81 Produce</option>
                                        <option value="441">8bit</option>
                                        <option value="56">A-1 Pictures</option>
                                        <option value="171">A-Line</option>
                                        <option value="1257">A-Real</option>
                                        <option value="1635">A-Sketch</option>
                                        <option value="179">A.C.G.T.</option>
                                        <option value="1500">ABC Animation</option>
                                        <option value="667">AC Create</option>
                                        <option value="589">Academy Productions</option>
                                        <option value="420">ACC Production</option>
                                        <option value="289">ACiD FiLM</option>
                                        <option value="60">Actas</option>
                                        <option value="121">Active</option>
                                        <option value="1502">Adores</option>
                                        <option value="410">Adult Source Media</option>
                                        <option value="97">ADV Films</option>
                                        <option value="785">Advance Syakujii</option>
                                        <option value="1580">AG-ONE</option>
                                        <option value="182">Age</option>
                                        <option value="1225">Age Global Networks</option>
                                        <option value="183">Agent 21</option>
                                        <option value="1041">Ai Addiction</option>
                                        <option value="184">Ai ga areba Daijobu</option>
                                        <option value="48">AIC</option>
                                        <option value="88">AIC A.S.T.A.</option>
                                        <option value="436">AIC Build</option>
                                        <option value="1306">AIC Classic</option>
                                        <option value="805">AIC Frontier</option>
                                        <option value="292">AIC Plus+</option>
                                        <option value="83">AIC Spirits</option>
                                        <option value="425">AIC Takarazuka</option>
                                        <option value="1083">Aikikaku Center</option>
                                        <option value="185">Aiko</option>
                                        <option value="1246">AIR AGENCY</option>
                                        <option value="30">Ajia-Do</option>
                                        <option value="1398">Akabanten</option>
                                        <option value="1373">Akita Shoten</option>
                                        <option value="809">AKOM</option>
                                        <option value="172">Alchemist</option>
                                        <option value="1161">Allure</option>
                                        <option value="827">Amber Film Works</option>
                                        <option value="779">AMG MUSIC</option>
                                        <option value="1401">Amgakuin</option>
                                        <option value="408">Amino</option>
                                        <option value="1313">Amuse</option>
                                        <option value="380">Amuse Pictures</option>
                                        <option value="878">An DerCen</option>
                                        <option value="488">Anchor Bay Films</option>
                                        <option value="975">Angelfish</option>
                                        <option value="194">ANIK</option>
                                        <option value="124">Animac</option>
                                        <option value="1243">AniMan</option>
                                        <option value="386">Animaruya</option>
                                        <option value="155">Animate Film</option>
                                        <option value="1449">Animatic</option>
                                        <option value="326">Animation 21</option>
                                        <option value="929">Animation Do</option>
                                        <option value="1528">Animatsu Entertainment</option>
                                        <option value="140">Animax</option>
                                        <option value="1463">Anime Antenna Iinkai</option>
                                        <option value="1510">Anime Consortium Japan</option>
                                        <option value="277">Anime Midstream</option>
                                        <option value="971">Anime R</option>
                                        <option value="310">AnimEigo</option>
                                        <option value="17">Aniplex</option>
                                        <option value="493">Aniplex of America</option>
                                        <option value="919">Ankama</option>
                                        <option value="583">Annapuru</option>
                                        <option value="521">Anpro</option>
                                        <option value="747">Apollon</option>
                                        <option value="77">APPP</option>
                                        <option value="1329">AQUAPLUS</option>
                                        <option value="1445">Arcs Create</option>
                                        <option value="1282">Arcturus</option>
                                        <option value="297">Armor</option>
                                        <option value="38">Arms</option>
                                        <option value="585">Arplants</option>
                                        <option value="8">Artland</option>
                                        <option value="72">Artmic</option>
                                        <option value="1415">Asahi Broadcasting Corporation</option>
                                        <option value="406">Asahi Production</option>
                                        <option value="1318">Asahi Shimbun</option>
                                        <option value="142">Asatsu DK</option>
                                        <option value="473">Ascension</option>
                                        <option value="681">ASCII Media Works</option>
                                        <option value="242">Ashi Productions</option>
                                        <option value="1021">ASIA Documentary Productions</option>
                                        <option value="517">Asmik Ace Entertainment</option>
                                        <option value="163">Asread</option>
                                        <option value="1271">Assez Finaud Fabric</option>
                                        <option value="1399">Asura Film</option>
                                        <option value="579">AT-2</option>
                                        <option value="238">AT-X</option>
                                        <option value="1175">Atelier Musa</option>
                                        <option value="344">Atlus</option>
                                        <option value="1009">Aubec</option>
                                        <option value="645">Audio Highs</option>
                                        <option value="1506">Audio Planning U</option>
                                        <option value="1461">Audio Tanaka</option>
                                        <option value="482">Automatic Flowers Studio</option>
                                        <option value="379">Avaco Creative Studios</option>
                                        <option value="52">Avex Entertainment</option>
                                        <option value="1284">Avex Pictures</option>
                                        <option value="1299">AXsiZ</option>
                                        <option value="907">AYCO</option>
                                        <option value="1191">Azeta Pictures</option>
                                        <option value="1429">Azumaker</option>
                                        <option value="1462">B&amp;T</option>
                                        <option value="1610">Baku Enterprise</option>
                                        <option value="230">Bandai</option>
                                        <option value="1588">Bandai Channel</option>
                                        <option value="233">Bandai Entertainment</option>
                                        <option value="1233">Bandai Namco Entertainment</option>
                                        <option value="1097">Bandai Namco Games</option>
                                        <option value="687">Bandai Namco Live Creative</option>
                                        <option value="1258">Bandai Namco Pictures</option>
                                        <option value="1544">Bandai Namco Rights Marketing</option>
                                        <option value="23">Bandai Visual</option>
                                        <option value="1466">Bandai Visual USA</option>
                                        <option value="1121">Banpresto</option>
                                        <option value="961">Baramiri</option>
                                        <option value="271">Barnum Studio</option>
                                        <option value="1139">BEAM Entertainment</option>
                                        <option value="59">Beat Frog</option>
                                        <option value="322">Bee Media</option>
                                        <option value="5">Bee Train</option>
                                        <option value="1029">BeeWorks</option>
                                        <option value="1456">Beijing Huihuang Animation Company</option>
                                        <option value="458">Beijing Sharaku Art</option>
                                        <option value="1341">Beijing Sunchime Happy Culture Company</option>
                                        <option value="1285">Being</option>
                                        <option value="1043">Benesse Corporation</option>
                                        <option value="89">BeSTACK</option>
                                        <option value="1584">Beyond C.</option>
                                        <option value="1157">Big Bang</option>
                                        <option value="351">Big West</option>
                                        <option value="789">BIGLOBE</option>
                                        <option value="1414">bilibili</option>
                                        <option value="1432">Bishop</option>
                                        <option value="1326">Bitgang</option>
                                        <option value="1547">Blade</option>
                                        <option value="445">Bliss Pictures</option>
                                        <option value="1385">Blue Cat</option>
                                        <option value="387">Blue Eyes</option>
                                        <option value="174">Blue Impact</option>
                                        <option value="157">BMG Japan</option>
                                        <option value="4">Bones</option>
                                        <option value="981">BOOTLEG</option>
                                        <option value="1487">Bouncy</option>
                                        <option value="112">Brain's Base</option>
                                        <option value="1093">BreakBottle</option>
                                        <option value="397">Bridge</option>
                                        <option value="116">Broccoli</option>
                                        <option value="843">BS Fuji</option>
                                        <option value="1469">BS Japan</option>
                                        <option value="214">BS-i</option>
                                        <option value="693">BS-TBS</option>
                                        <option value="1416">BS11</option>
                                        <option value="1279">Buemon</option>
                                        <option value="1579">Bulls Eye</option>
                                        <option value="1619">Bungeishunjuu</option>
                                        <option value="775">Bushiroad</option>
                                        <option value="1634">Bushiroad Music</option>
                                        <option value="491">Byakuya Shobo</option>
                                        <option value="1497">C &amp; I entertainment</option>
                                        <option value="1075">C-Station</option>
                                        <option value="605">C2C</option>
                                        <option value="1063">Calf Studio</option>
                                        <option value="609">Cammot</option>
                                        <option value="240">Capcom</option>
                                        <option value="933">Carp Studio</option>
                                        <option value="328">Casio Entertainment</option>
                                        <option value="146">CBC</option>
                                        <option value="1480">CBS</option>
                                        <option value="1301">CCTV Animation Co. LTD</option>
                                        <option value="284">Central Park Media</option>
                                        <option value="462">Chaos Project</option>
                                        <option value="665">chara-ani.com</option>
                                        <option value="856">Charaction</option>
                                        <option value="130">CherryLips</option>
                                        <option value="1628">Chiba TV</option>
                                        <option value="402">ChiChinoya</option>
                                        <option value="1407">Children's Playground Entertainment</option>
                                        <option value="1546">Chippai</option>
                                        <option value="1639">Chiptune</option>
                                        <option value="1288">Chrono Gear Creative</option>
                                        <option value="401">ChuChu</option>
                                        <option value="1336">Chugai Mining Co., Ltd.</option>
                                        <option value="353">Chungeorahm Film</option>
                                        <option value="1405">Chuubu Nihon Kyouei</option>
                                        <option value="1586">CIC</option>
                                        <option value="1484">Cinelicious Pics</option>
                                        <option value="886">Cinema Tohoku</option>
                                        <option value="1384">CinePix</option>
                                        <option value="1642">Circle Tribute</option>
                                        <option value="1395">Clarion</option>
                                        <option value="995">Coamix</option>
                                        <option value="1460">Coastline Animation Studio</option>
                                        <option value="325">Code</option>
                                        <option value="519">Collaboration Works</option>
                                        <option value="1613">COLOPL</option>
                                        <option value="1207">Comic Umenohone</option>
                                        <option value="1481">comico</option>
                                        <option value="291">CoMix Wave Films</option>
                                        <option value="1141">Comstock, Ltd.</option>
                                        <option value="957">Connect</option>
                                        <option value="1554">Contents Seed</option>
                                        <option value="451">Cookie Jar Entertainment</option>
                                        <option value="1535">Coolism Productions</option>
                                        <option value="745">Cosmic Ray</option>
                                        <option value="1085">Cosmos</option>
                                        <option value="619">Cospa</option>
                                        <option value="821">Cotton Doll</option>
                                        <option value="1357">Craftar</option>
                                        <option value="356">Cranberry</option>
                                        <option value="987">Creative Bridge</option>
                                        <option value="1322">Creative Power Entertaining</option>
                                        <option value="1195">Creators in Pack</option>
                                        <option value="1490">CREi</option>
                                        <option value="965">Crimson Star Media</option>
                                        <option value="296">Critical Mass Video</option>
                                        <option value="551">Crossphere</option>
                                        <option value="1468">Crunchyroll</option>
                                        <option value="1422">CyberAgent</option>
                                        <option value="231">CyberConnect2</option>
                                        <option value="923">CyberStep</option>
                                        <option value="1099">Cyclone Graphics inc</option>
                                        <option value="1587">Cygames</option>
                                        <option value="164">d-rights</option>
                                        <option value="567">D.A.S.T.</option>
                                        <option value="244">D3</option>
                                        <option value="228">Daewon Media</option>
                                        <option value="1549">Dai Nippon Printing</option>
                                        <option value="1512">Daichi Doga</option>
                                        <option value="278">Daiei</option>
                                        <option value="1632">Daiichi Shokai CO., LTD</option>
                                        <option value="1215">Daiichikosho</option>
                                        <option value="983">Daiko</option>
                                        <option value="1111">DandeLion Animation Studio LLC</option>
                                        <option value="1361">Darts</option>
                                        <option value="39">Daume</option>
                                        <option value="287">David Production</option>
                                        <option value="315">DAX Production</option>
                                        <option value="1328">Decovocal</option>
                                        <option value="711">Delfi Sound</option>
                                        <option value="1576">DeNA</option>
                                        <option value="53">Dentsu</option>
                                        <option value="1251">Dentsu Eigasha Tokyo</option>
                                        <option value="791">Dentsu Entertainment USA</option>
                                        <option value="1606">Dentsu Razorfish</option>
                                        <option value="1607">Dentsu Tec</option>
                                        <option value="1570">Design Factory</option>
                                        <option value="1338">Diabolik Lovers MB Project</option>
                                        <option value="269">DiC Entertainment</option>
                                        <option value="486">Digital Frontier</option>
                                        <option value="466">Digital Media Lab</option>
                                        <option value="206">Digital Works</option>
                                        <option value="1439">Digiturbo</option>
                                        <option value="51">Diomedea</option>
                                        <option value="324">Directions</option>
                                        <option value="467">Discotek Media</option>
                                        <option value="294">Discovery</option>
                                        <option value="1039">DIVE II Entertainment</option>
                                        <option value="276">DLE</option>
                                        <option value="1542">DMM.com</option>
                                        <option value="1334">Docomo Anime Store</option>
                                        <option value="95">Doga Kobo</option>
                                        <option value="479">DOGA Productions</option>
                                        <option value="1380">domerica</option>
                                        <option value="1025">Dongwoo A&amp;E</option>
                                        <option value="1513">Dongyang Animation</option>
                                        <option value="1575">DR movies.Movie</option>
                                        <option value="615">Dream Creation</option>
                                        <option value="399">Dream Force</option>
                                        <option value="1475">DreamWorks</option>
                                        <option value="1609">Duckbill Entertainment</option>
                                        <option value="715">Dwango</option>
                                        <option value="663">Dwango Music Entertainment</option>
                                        <option value="1133">dwarf</option>
                                        <option value="921">Dynamic Planning</option>
                                        <option value="1263">Dynamo Pictures</option>
                                        <option value="154">E&amp;G Films</option>
                                        <option value="925">Earth Star Entertainment</option>
                                        <option value="1501">East Japan Marketing &amp; Communications</option>
                                        <option value="1633">eBooK Initiative Japan CO., LTD</option>
                                        <option value="1427">EBS</option>
                                        <option value="258">Echo</option>
                                        <option value="1522">Echoes</option>
                                        <option value="1351">EDGE</option>
                                        <option value="593">Egg</option>
                                        <option value="1444">Egg Firm</option>
                                        <option value="1486">eigoMANGA</option>
                                        <option value="191">Eiken</option>
                                        <option value="1433">Ekura Animal</option>
                                        <option value="419">ElectromagneticWave</option>
                                        <option value="531">Elevenarts</option>
                                        <option value="815">EMI</option>
                                        <option value="1530">Emon</option>
                                        <option value="1264">EMT²</option>
                                        <option value="354">Encourage Films</option>
                                        <option value="1465">Enlight Pictures</option>
                                        <option value="311">Enoki Films</option>
                                        <option value="1330">ensky</option>
                                        <option value="392">Enterbrain</option>
                                        <option value="393">Epoch</option>
                                        <option value="1241">Evil Line Records</option>
                                        <option value="1598">EXA International</option>
                                        <option value="1594">Exit Tunes</option>
                                        <option value="759">Eye Move</option>
                                        <option value="1289">F.M.F</option>
                                        <option value="515">Fairy Dust</option>
                                        <option value="1332">famima.com</option>
                                        <option value="866">Fanworks</option>
                                        <option value="91">feel.</option>
                                        <option value="1440">Felix Film</option>
                                        <option value="699">feng</option>
                                        <option value="1358">Fields</option>
                                        <option value="825">Fifth Avenue</option>
                                        <option value="362">Film Workshop</option>
                                        <option value="426">Filmlink International</option>
                                        <option value="267">Five Ways</option>
                                        <option value="1163">Flatiron Film Company</option>
                                        <option value="1531">Flavors Soft</option>
                                        <option value="874">Flex Comics</option>
                                        <option value="464">flying DOG</option>
                                        <option value="1423">Forecast Communications</option>
                                        <option value="1135">FOREST Hunting One</option>
                                        <option value="285">Four Some</option>
                                        <option value="1307">Free-Will</option>
                                        <option value="1389">Frencel</option>
                                        <option value="69">Front Line</option>
                                        <option value="61">Frontier Works</option>
                                        <option value="1556">Fuji Creative Corporation</option>
                                        <option value="769">Fuji Pacific Music Publishing</option>
                                        <option value="169">Fuji TV</option>
                                        <option value="509">Fuji Video</option>
                                        <option value="1483">Fuji&amp;gumi Games</option>
                                        <option value="1315">Fujiko F. Fujio Pro</option>
                                        <option value="1656">FUJIYAMA PROJECT JAPAN</option>
                                        <option value="1314">Fukushima Gainax</option>
                                        <option value="102">FUNimation Entertainment</option>
                                        <option value="1590">Furyu</option>
                                        <option value="1377">Futabasha</option>
                                        <option value="340">Future Planet</option>
                                        <option value="131">G&amp;G Entertainment</option>
                                        <option value="1369">G-Lam</option>
                                        <option value="876">G-mode</option>
                                        <option value="1350">G.CMay Animation &amp; Film</option>
                                        <option value="470">GAGA</option>
                                        <option value="6">Gainax</option>
                                        <option value="198">Gakken</option>
                                        <option value="1091">Gakken Eigakyoku</option>
                                        <option value="721">GANSIS</option>
                                        <option value="1419">GARDEN LODGE</option>
                                        <option value="400">Gathering</option>
                                        <option value="42">GDH</option>
                                        <option value="1524">Geidai Animation</option>
                                        <option value="1177">Geijutsu Eigasha</option>
                                        <option value="1381">GEMBA</option>
                                        <option value="189">GEN Productions</option>
                                        <option value="1526">Gen'ei</option>
                                        <option value="79">Genco</option>
                                        <option value="1105">Gendai Production</option>
                                        <option value="1459">Geneon Entertainment USA</option>
                                        <option value="31">Geneon Universal Entertainment</option>
                                        <option value="1393">Geno Studio</option>
                                        <option value="282">Gentosha Comics</option>
                                        <option value="1636">Gigno Systems</option>
                                        <option value="880">gimik</option>
                                        <option value="176">Ginga Ya</option>
                                        <option value="783">GKids</option>
                                        <option value="793">Glams</option>
                                        <option value="1255">Glovision</option>
                                        <option value="302">GODxDOG Production</option>
                                        <option value="309">GoHands</option>
                                        <option value="3">Gonzo</option>
                                        <option value="1261">Good Smile Company</option>
                                        <option value="894">Graphinica</option>
                                        <option value="378">Grasshoppa!</option>
                                        <option value="152">Green Bunny</option>
                                        <option value="1254">Grooove</option>
                                        <option value="86">Group TAC</option>
                                        <option value="391">Grouper Productions</option>
                                        <option value="1602">GYAO!</option>
                                        <option value="649">Hakoniwa Academy Student Council</option>
                                        <option value="1563">Hakuhodo</option>
                                        <option value="1488">Hakuhodo DY Media Partners</option>
                                        <option value="1333">Hakuhodo DY Music &amp; Pictures</option>
                                        <option value="148">Hakusensha</option>
                                        <option value="34">Hal Film Maker</option>
                                        <option value="213">Half H.P Studio</option>
                                        <option value="811">Hang Zhou StarQ</option>
                                        <option value="1325">Haoliners Animation League</option>
                                        <option value="787">Happinet Pictures</option>
                                        <option value="1256">Harappa</option>
                                        <option value="465">Hasbro</option>
                                        <option value="1217">HeART-BIT</option>
                                        <option value="367">Heewon Entertainment</option>
                                        <option value="447">Hero Communication</option>
                                        <option value="1503">Heroz</option>
                                        <option value="527">Higa Brothers Production</option>
                                        <option value="1539">Highlights Entertainment</option>
                                        <option value="138">Himajin Planning</option>
                                        <option value="1019">Himeyuri Alumnae Incorporated Foundation</option>
                                        <option value="1464">Hiro Media</option>
                                        <option value="1310">Hiroshi Planning</option>
                                        <option value="1457">Hisashishi Videos</option>
                                        <option value="547">Hobby Japan</option>
                                        <option value="1347">Hobi Animation</option>
                                        <option value="1495">Hobibox</option>
                                        <option value="1219">Hokkaido Azmacy</option>
                                        <option value="1221">Hokkaido Cultural Broadcasting</option>
                                        <option value="1360">Hoods Drifters Studio</option>
                                        <option value="346">Hoods Entertainment</option>
                                        <option value="492">Horannabi</option>
                                        <option value="134">HoriPro</option>
                                        <option value="991">Hoso Seisaku Doga</option>
                                        <option value="268">Hot Bear</option>
                                        <option value="723">Hotline</option>
                                        <option value="797">Houbunsha</option>
                                        <option value="1276">HS Pictures Studio</option>
                                        <option value="1235">I was a Ballerina</option>
                                        <option value="1605">I Will</option>
                                        <option value="389">I-move</option>
                                        <option value="375">I.Toon</option>
                                        <option value="1331">i0+</option>
                                        <option value="1582">Ichijinsha</option>
                                        <option value="193">Idea Factory</option>
                                        <option value="1169">ILCA</option>
                                        <option value="1527">Image House</option>
                                        <option value="1153">Image Kei</option>
                                        <option value="255">Imagi</option>
                                        <option value="170">Imagica</option>
                                        <option value="1277">Imagica West</option>
                                        <option value="75">Imagin</option>
                                        <option value="331">Indeprox</option>
                                        <option value="870">Index</option>
                                        <option value="799">indigo line</option>
                                        <option value="1386">Infinite</option>
                                        <option value="469">ING</option>
                                        <option value="357">Innocent Grey</option>
                                        <option value="421">International Digital Artist</option>
                                        <option value="731">Inu x Boku SS Production Partners</option>
                                        <option value="475">Ishikawa Pro</option>
                                        <option value="1437">Ishimori Entertainment</option>
                                        <option value="1561">Ishimori Pro</option>
                                        <option value="1353">Issen</option>
                                        <option value="349">Itasca Studio</option>
                                        <option value="941">Iwatobi High School Swimming Club</option>
                                        <option value="601">ixtl</option>
                                        <option value="370">Iyasakadou Film</option>
                                        <option value="7">J.C.Staff</option>
                                        <option value="222">Jade Animation</option>
                                        <option value="257">Jam</option>
                                        <option value="342">Japan Home Video</option>
                                        <option value="1629">Japan Sleeve</option>
                                        <option value="1545">Japan Taps</option>
                                        <option value="1037">Japan Vistec</option>
                                        <option value="573">JapanAnime</option>
                                        <option value="1435">JCF</option>
                                        <option value="1517">Jinnan Studio</option>
                                        <option value="444">Jinnis Animation Studios</option>
                                        <option value="336">JM animation</option>
                                        <option value="1320">Joker Films</option>
                                        <option value="613">Jormungand Production Partners</option>
                                        <option value="1646">JP Room</option>
                                        <option value="1538">JTB Entertainment</option>
                                        <option value="360">Jules Bass</option>
                                        <option value="755">Jumondo</option>
                                        <option value="1645">Just Pro</option>
                                        <option value="1269">K-Factory</option>
                                        <option value="432">Kachidoki Studio</option>
                                        <option value="685">Kadokawa Contents Gate</option>
                                        <option value="1540">Kadokawa Media (Taiwan)</option>
                                        <option value="1551">Kadokawa Media House</option>
                                        <option value="352">Kadokawa Pictures Japan</option>
                                        <option value="262">Kadokawa Pictures USA</option>
                                        <option value="113">Kadokawa Shoten</option>
                                        <option value="259">Kaeruotoko Shokai</option>
                                        <option value="525">KAGAYA Studio</option>
                                        <option value="1649">Kakao Japan</option>
                                        <option value="437">Kamikaze Douga</option>
                                        <option value="1592">Kamio Japan</option>
                                        <option value="330">Kanaban Graphics</option>
                                        <option value="288">Kaname Productions</option>
                                        <option value="1494">Kanon Sound</option>
                                        <option value="1412">Kansai Telecasting Corporation</option>
                                        <option value="890">Karaku</option>
                                        <option value="575">Katsudou-manga-kan</option>
                                        <option value="348">Kawamoto Productions</option>
                                        <option value="848">Kazami Gakuen Koushiki Douga-bu</option>
                                        <option value="1368">Kazuki Production</option>
                                        <option value="411">KBS</option>
                                        <option value="1621">Keisei Electric Railway</option>
                                        <option value="850">Kenji Studio</option>
                                        <option value="283">KENMedia</option>
                                        <option value="1239">KeyEast</option>
                                        <option value="47">Khara</option>
                                        <option value="158">Kids Station</option>
                                        <option value="623">Kimi To Boku Production Partners</option>
                                        <option value="290">Kinema Citrus</option>
                                        <option value="1159">King Bee</option>
                                        <option value="1344">King Records</option>
                                        <option value="477">Kino Production</option>
                                        <option value="1653">Kinoshita Group Holdings</option>
                                        <option value="1346">Kinoshita Koumuten</option>
                                        <option value="99">Kitty Films</option>
                                        <option value="321">Kitty Media</option>
                                        <option value="727">Kiyosumi High School Mahjong Club</option>
                                        <option value="460">KlockWorx</option>
                                        <option value="383">KMMJ Studios</option>
                                        <option value="535">Knack Animation</option>
                                        <option value="452">Knack Productions</option>
                                        <option value="1559">Kobunsha</option>
                                        <option value="159">Kodansha</option>
                                        <option value="241">Koei</option>
                                        <option value="1498">Koei Tecmo Games</option>
                                        <option value="275">Kojiro Shishido Animation Works</option>
                                        <option value="281">Kokusai Eigasha</option>
                                        <option value="85">Konami</option>
                                        <option value="1470">Konami Digital Entertainment</option>
                                        <option value="1291">KOO-KI</option>
                                        <option value="50">KSS</option>
                                        <option value="1640">Kujou-kun no Bonnou wo Mimamoru Kai</option>
                                        <option value="377">Kuri Jikken Manga Kobo</option>
                                        <option value="1001">Kyodo Eiga</option>
                                        <option value="1411">Kyoraku Industrial Holdings</option>
                                        <option value="2">Kyoto Animation</option>
                                        <option value="833">Kyotoma</option>
                                        <option value="1057">Kyowa Film</option>
                                        <option value="1199">L.</option>
                                        <option value="1101">Lambert</option>
                                        <option value="563">LandQ studios</option>
                                        <option value="301">Langmaor</option>
                                        <option value="104">Lantis</option>
                                        <option value="529">Lapis</option>
                                        <option value="896">Larx Entertainment</option>
                                        <option value="1408">Lastrum Music</option>
                                        <option value="1496">Lawson</option>
                                        <option value="1309">Lawson HMV Entertainment</option>
                                        <option value="1087">Lay-duce</option>
                                        <option value="1268">L²Studio</option>
                                        <option value="414">Lemon Heart</option>
                                        <option value="456">Lerche</option>
                                        <option value="1428">Level-5</option>
                                        <option value="839">LIDENFILMS</option>
                                        <option value="312">Life Work</option>
                                        <option value="1485">Light Chaser Animation Studios</option>
                                        <option value="1017">Liverpool</option>
                                        <option value="565">LMD</option>
                                        <option value="1123">Lucent Pictures Entertainment</option>
                                        <option value="657">Lucky Paradise</option>
                                        <option value="823">Lune Pictures</option>
                                        <option value="40">m.o.e.</option>
                                        <option value="463">M.S.C</option>
                                        <option value="1529">M2</option>
                                        <option value="430">Mad Box</option>
                                        <option value="11">Madhouse</option>
                                        <option value="627">Madoka Partners</option>
                                        <option value="1452">Mag Garden</option>
                                        <option value="963">MAGES.</option>
                                        <option value="207">Magic Bus</option>
                                        <option value="306">Magic Capsule</option>
                                        <option value="1073">Magic Lantern Film</option>
                                        <option value="490">Maiden Japan</option>
                                        <option value="449">Maikaze</option>
                                        <option value="143">Mainichi Broadcasting System</option>
                                        <option value="1603">Mainichi Shimbun</option>
                                        <option value="767">Majin</option>
                                        <option value="947">Manga Entertainment</option>
                                        <option value="32">Manglobe</option>
                                        <option value="569">MAPPA</option>
                                        <option value="1363">Marine Entertainment</option>
                                        <option value="320">Maru Production</option>
                                        <option value="165">Marubeni</option>
                                        <option value="483">Marvel Entertainment</option>
                                        <option value="751">Marvelous AQL</option>
                                        <option value="82">Marvelous Entertainment</option>
                                        <option value="553">Marvy Jack</option>
                                        <option value="424">Mary Jane</option>
                                        <option value="1296">Marza Animation Planet</option>
                                        <option value="997">Maxell E-Cube</option>
                                        <option value="637">Möbius Tone</option>
                                        <option value="1424">Media Bank</option>
                                        <option value="250">Media Blasters</option>
                                        <option value="1280">Media Castle</option>
                                        <option value="1520">Media Do</option>
                                        <option value="108">Media Factory</option>
                                        <option value="1378">Media Rings</option>
                                        <option value="135">MediaNet</option>
                                        <option value="1337">Medicos Entertainment</option>
                                        <option value="1438">Medicrie</option>
                                        <option value="1403">Meiji Seika</option>
                                        <option value="71">Mellow Head</option>
                                        <option value="647">Memory-Tech</option>
                                        <option value="1305">Milestone Music Publishing</option>
                                        <option value="1027">Milkshake</option>
                                        <option value="25">Milky Animation Label</option>
                                        <option value="398">Milky Cartoon</option>
                                        <option value="1237">Millepensee</option>
                                        <option value="442">Minami Machi Bugyousho</option>
                                        <option value="1477">Ministry of the Navy</option>
                                        <option value="1441">Mippei Eigeki Kiryuukan</option>
                                        <option value="1406">Miracle Bus</option>
                                        <option value="763">Miracle Robo</option>
                                        <option value="1249">Mirai Film</option>
                                        <option value="1644">Mirai Records</option>
                                        <option value="501">Miramax Films</option>
                                        <option value="394">Misseri Studio</option>
                                        <option value="1247">Mistral Japan</option>
                                        <option value="1564">Mitsubishi</option>
                                        <option value="1179">MK Pictures</option>
                                        <option value="1077">MMDGP</option>
                                        <option value="201">MMG</option>
                                        <option value="1213">Mobcast</option>
                                        <option value="1409">Monomusik</option>
                                        <option value="1193">MooGoo</option>
                                        <option value="54">Mook Animation</option>
                                        <option value="1442">Mook DLE</option>
                                        <option value="495">Moonstone Cherry</option>
                                        <option value="1525">Moss Design Unit</option>
                                        <option value="166">Movic</option>
                                        <option value="319">MS Pictures</option>
                                        <option value="68">Mushi Production</option>
                                        <option value="1472">Myung Films</option>
                                        <option value="533">N&amp;G Production</option>
                                        <option value="1612">NADA Holdings</option>
                                        <option value="1366">Nagoya TV Housou</option>
                                        <option value="1260">Nakamura Production</option>
                                        <option value="1536">Namu Animation</option>
                                        <option value="697">Natsuiro Kiseki Production Partners</option>
                                        <option value="266">Natural High</option>
                                        <option value="951">NAZ</option>
                                        <option value="1113">NBCUniversal Entertainment Japan</option>
                                        <option value="1446">NEC Avenue</option>
                                        <option value="1387">Neft Film</option>
                                        <option value="1555">Nelke Planning</option>
                                        <option value="215">Nelvana</option>
                                        <option value="1448">Network</option>
                                        <option value="677">Nexon</option>
                                        <option value="1491">Next</option>
                                        <option value="819">Next Media Animation</option>
                                        <option value="852">Nexus</option>
                                        <option value="111">NHK</option>
                                        <option value="359">NHK-BS2</option>
                                        <option value="428">Nichiei Agency</option>
                                        <option value="1589">NichiNare</option>
                                        <option value="1585">Nichion</option>
                                        <option value="801">Nihikime no Dozeu</option>
                                        <option value="139">Nihon Ad Systems</option>
                                        <option value="1532">Nihon Eizo</option>
                                        <option value="468">Nihon Falcom</option>
                                        <option value="989">Nihon Hoso Eigasha</option>
                                        <option value="513">Nikkatsu</option>
                                        <option value="1167">Nikkatsu Mukojima</option>
                                        <option value="503">Nintendo</option>
                                        <option value="505">Nintendo of America</option>
                                        <option value="22">Nippon Animation</option>
                                        <option value="323">Nippon Columbia</option>
                                        <option value="1577">Nippon Cultural Broadcasting</option>
                                        <option value="1623">Nippon Ichi Software</option>
                                        <option value="316">Nippon Shuppan Hanbai (Nippan) K.K.</option>
                                        <option value="1418">Nippon Television Music Corporation</option>
                                        <option value="1003">Nippon Television Network Corporation</option>
                                        <option value="372">NIS America, Inc.</option>
                                        <option value="1548">Nishinippon Broadcasting Company</option>
                                        <option value="459">Nitroplus</option>
                                        <option value="70">Nomad</option>
                                        <option value="1534">North Stars Pictures</option>
                                        <option value="703">Notes</option>
                                        <option value="892">NOTTV</option>
                                        <option value="217">Nozomi Entertainment</option>
                                        <option value="689">NTT Docomo</option>
                                        <option value="1614">NTT Plala</option>
                                        <option value="1567">NUT</option>
                                        <option value="270">NuTech Digital</option>
                                        <option value="595">NYAV Post</option>
                                        <option value="67">OB Planning</option>
                                        <option value="571">Obtain Future</option>
                                        <option value="1005">Oddjob</option>
                                        <option value="1473">Odolttogi</option>
                                        <option value="429">Office AO</option>
                                        <option value="1281">Office DCI</option>
                                        <option value="1300">Office Nobu</option>
                                        <option value="481">Office Take Off</option>
                                        <option value="1374">Office Takeout</option>
                                        <option value="234">Oh! Production</option>
                                        <option value="461">OLE-M</option>
                                        <option value="1171">Olive Studio</option>
                                        <option value="28">OLM</option>
                                        <option value="1231">OLM Digital</option>
                                        <option value="313">Omnibus Japan</option>
                                        <option value="1624">On The Run</option>
                                        <option value="1600">On-Lead</option>
                                        <option value="1013">Opera House</option>
                                        <option value="1109">Orange</option>
                                        <option value="1654">Orchid Seed</option>
                                        <option value="334">Ordet</option>
                                        <option value="1273">Osaka University of Arts</option>
                                        <option value="831">Otogi Production</option>
                                        <option value="1443">Overlap</option>
                                        <option value="361">Oxybot</option>
                                        <option value="395">Oz</option>
                                        <option value="985">P Productions</option>
                                        <option value="132">P.A. Works</option>
                                        <option value="455">Palm Studio</option>
                                        <option value="1565">Panasonic Digital Contents</option>
                                        <option value="373">Panda Factory</option>
                                        <option value="226">Panmedia</option>
                                        <option value="1303">PansonWorks</option>
                                        <option value="862">Pashmina</option>
                                        <option value="911">Passione</option>
                                        <option value="413">Pastel</option>
                                        <option value="1568">Pazzy Entertainment</option>
                                        <option value="1478">Pencil</option>
                                        <option value="1354">Penta Show Studios</option>
                                        <option value="773">Peter Pan Creation</option>
                                        <option value="329">Phoenix Entertainment</option>
                                        <option value="293">Picograph</option>
                                        <option value="78">Picture Magic</option>
                                        <option value="1229">Pie in The Sky</option>
                                        <option value="1467">Pied Piper</option>
                                        <option value="1129">Pierrot Plus</option>
                                        <option value="1382">Piko Studio</option>
                                        <option value="1295">Pine Jam</option>
                                        <option value="45">Pink Pineapple</option>
                                        <option value="204">Pioneer LDC</option>
                                        <option value="195">Pixy</option>
                                        <option value="175">Planet</option>
                                        <option value="1471">Platinum Vision</option>
                                        <option value="107">Plum</option>
                                        <option value="374">Plus Heads</option>
                                        <option value="1630">Plus One</option>
                                        <option value="807">Po10tial</option>
                                        <option value="1290">Pollyanna Graphics</option>
                                        <option value="1023">Polygon Pictures</option>
                                        <option value="156">Polygram Japan</option>
                                        <option value="931">Poncotan</option>
                                        <option value="144">Pony Canyon</option>
                                        <option value="1557">Pony Canyon Enterprise</option>
                                        <option value="1201">Ponycan USA</option>
                                        <option value="1049">PoPoCo</option>
                                        <option value="365">PoRO</option>
                                        <option value="448">Postgal Workshop</option>
                                        <option value="137">PPM</option>
                                        <option value="709">PPP</option>
                                        <option value="753">PRA</option>
                                        <option value="304">Primastea</option>
                                        <option value="347">PrimeTime</option>
                                        <option value="431">Procidis</option>
                                        <option value="1651">Production Ace</option>
                                        <option value="1317">Production GoodBook</option>
                                        <option value="10">Production I.G</option>
                                        <option value="1053">Production IMS</option>
                                        <option value="196">Production Reed</option>
                                        <option value="743">Project Eureka AO</option>
                                        <option value="739">Project IS</option>
                                        <option value="1508">project lights</option>
                                        <option value="845">Project No Name</option>
                                        <option value="439">Project No.9</option>
                                        <option value="705">Project Railgun</option>
                                        <option value="1061">Project Team Eikyuu Kikan</option>
                                        <option value="1404">PSG</option>
                                        <option value="1065">Public &amp; Basic</option>
                                        <option value="559">Purple Cow Studio Japan</option>
                                        <option value="343">Puzzle Animation Studio Limited</option>
                                        <option value="1287">Q-Tec</option>
                                        <option value="1655">QREAZY</option>
                                        <option value="1304">Qualia Animation</option>
                                        <option value="1574">Quaras</option>
                                        <option value="1595">Quatre Stella</option>
                                        <option value="977">Queen Bee</option>
                                        <option value="1417">RAB Aomori Broadcasting Corporation</option>
                                        <option value="1107">Rabbit Gate</option>
                                        <option value="1362">Rabbit Machine</option>
                                        <option value="1631">Radio Osaka</option>
                                        <option value="81">Radix</option>
                                        <option value="729">Raku High Student Council</option>
                                        <option value="211">Rakuonsha</option>
                                        <option value="1410">Rambling Records</option>
                                        <option value="607">RAMS</option>
                                        <option value="339">Rankin/Bass</option>
                                        <option value="1581">RAY</option>
                                        <option value="190">RCC Chugoku Broadcasting</option>
                                        <option value="1454">REALTHING</option>
                                        <option value="49">Remic</option>
                                        <option value="1181">RG Animation Studios</option>
                                        <option value="661">Right Gauge</option>
                                        <option value="1394">RightTracks</option>
                                        <option value="253">Rikuentai</option>
                                        <option value="1187">Ripple Film</option>
                                        <option value="1489">Ripromo</option>
                                        <option value="1519">Rironsha</option>
                                        <option value="1067">Rising Force</option>
                                        <option value="249">Robot</option>
                                        <option value="1618">Rockwell Eyes</option>
                                        <option value="1302">RoiVisual</option>
                                        <option value="591">Romanov Films</option>
                                        <option value="1293">Romantica club !!</option>
                                        <option value="160">Rondo Robe</option>
                                        <option value="446">RTHK</option>
                                        <option value="264">Ruby-Spears Productions</option>
                                        <option value="913">Ryukyu Asahi Broadcasting</option>
                                        <option value="1323">Saban Brands</option>
                                        <option value="841">Saban Entertainment</option>
                                        <option value="1242">Sakura Color Film</option>
                                        <option value="765">Sakura Create</option>
                                        <option value="1298">Sakura Motion Picture</option>
                                        <option value="611">Sakura Production</option>
                                        <option value="341">SamBakZa</option>
                                        <option value="1345">Sammy</option>
                                        <option value="261">San-X</option>
                                        <option value="1270">Sanctuary</option>
                                        <option value="1311">Sankyo Planning</option>
                                        <option value="150">Sanrio</option>
                                        <option value="1151">Sanrio Digital</option>
                                        <option value="1515">Sanyo</option>
                                        <option value="1552">Sanyo Bussan</option>
                                        <option value="537">SANZIGEN</option>
                                        <option value="41">Satelight</option>
                                        <option value="98">Sav! The World Productions</option>
                                        <option value="523">SBS TV Production</option>
                                        <option value="422">Schoolzone</option>
                                        <option value="1591">Science SARU</option>
                                        <option value="1308">SEDIC International</option>
                                        <option value="167">Sega</option>
                                        <option value="701">Seikaisha</option>
                                        <option value="1137">SEK Studios</option>
                                        <option value="847">Senran Kagura Partners</option>
                                        <option value="376">Sentai Filmworks</option>
                                        <option value="335">Seta Corporation</option>
                                        <option value="541">Seven</option>
                                        <option value="35">Seven Arcs</option>
                                        <option value="1569">Seven Arcs Pictures</option>
                                        <option value="44">Shaft</option>
                                        <option value="471">Shanghai Animation Film Studio</option>
                                        <option value="1611">Shanghai Tiantan Culture &amp; Media CO., LTD</option>
                                        <option value="168">Shelty</option>
                                        <option value="1324">Shimogumi</option>
                                        <option value="247">Shin-Ei Animation</option>
                                        <option value="1147">Shinano Kikaku</option>
                                        <option value="1550">Shinchosha Publishing</option>
                                        <option value="872">Shingeki no Kyojin Team</option>
                                        <option value="192">Shinkuukan</option>
                                        <option value="485">Shinwon Productions</option>
                                        <option value="133">Shinyusha</option>
                                        <option value="235">Shirogumi</option>
                                        <option value="1359">Shizuoka Broadcasting System</option>
                                        <option value="109">Shochiku</option>
                                        <option value="1476">Shochiku Animation Institute</option>
                                        <option value="1626">Shochiku Music Publishing</option>
                                        <option value="1430">Shogakukan</option>
                                        <option value="474">Shogakukan Music &amp; Digital Entertainment</option>
                                        <option value="62">Shogakukan Productions</option>
                                        <option value="1553">Shounen Gahousha</option>
                                        <option value="777">Showgate</option>
                                        <option value="1365">Shueisha</option>
                                        <option value="1119">Shuka</option>
                                        <option value="260">Shuuhei Morita</option>
                                        <option value="1420">SIDO LIMITED</option>
                                        <option value="1278">Signal. MD</option>
                                        <option value="129">Silky’s</option>
                                        <option value="300">Silver Link.</option>
                                        <option value="279">Skouras</option>
                                        <option value="147">SKY Perfect Well Think</option>
                                        <option value="735">Slowcurve</option>
                                        <option value="149">SME Visual Works</option>
                                        <option value="1647">Smiral Animation</option>
                                        <option value="1372">SOEISHINSHA</option>
                                        <option value="254">Soft Garage</option>
                                        <option value="953">Soft on Demand</option>
                                        <option value="621">SoftBank Creative Corp.</option>
                                        <option value="813">SoftCel Pictures</option>
                                        <option value="153">SoftX</option>
                                        <option value="161">Sogo Vision</option>
                                        <option value="209">Sol Blade</option>
                                        <option value="1189">Sola Digital Arts</option>
                                        <option value="854">Solid Vox</option>
                                        <option value="737">Sony Music Communications</option>
                                        <option value="757">Sony Music Entertainment</option>
                                        <option value="1516">Sony PCL</option>
                                        <option value="15">Sony Pictures Entertainment</option>
                                        <option value="64">Sotsu</option>
                                        <option value="1597">Sotsu Music Publishing</option>
                                        <option value="128">Souten Studio</option>
                                        <option value="364">Sovat Theater</option>
                                        <option value="679">Soyuzmultfilm</option>
                                        <option value="1045">Space Neko Company Ltd.</option>
                                        <option value="1343">Space Shower Music</option>
                                        <option value="581">Sparky Animation</option>
                                        <option value="979">SPEED</option>
                                        <option value="1391">SPO Entertainment</option>
                                        <option value="1370">Sprite Animation Studios</option>
                                        <option value="58">Square Enix</option>
                                        <option value="92">Starchild Records</option>
                                        <option value="1601">Stardust Promotion</option>
                                        <option value="1197">Steve N' Steven</option>
                                        <option value="1436">Sting Ray</option>
                                        <option value="884">Strawberry Meets Pictures</option>
                                        <option value="1203">Studio 1st</option>
                                        <option value="1127">Studio 3Hz</option>
                                        <option value="13">Studio 4°C</option>
                                        <option value="407">Studio 9 MAiami</option>
                                        <option value="1209">Studio A-CAT</option>
                                        <option value="298">Studio Anima</option>
                                        <option value="999">Studio Animal</option>
                                        <option value="1641">Studio AWAKE</option>
                                        <option value="1252">Studio Binzo</option>
                                        <option value="478">Studio Blanc</option>
                                        <option value="338">Studio Bogey</option>
                                        <option value="1149">Studio Cab</option>
                                        <option value="1599">Studio CHANT</option>
                                        <option value="555">Studio Chizu</option>
                                        <option value="1095">Studio Cockpit</option>
                                        <option value="1033">Studio Colorido</option>
                                        <option value="126">Studio Comet</option>
                                        <option value="959">Studio Compile</option>
                                        <option value="1479">Studio Core</option>
                                        <option value="1259">Studio Curtain</option>
                                        <option value="1173">Studio Dadashow</option>
                                        <option value="37">Studio Deen</option>
                                        <option value="545">Studio Deva Loka</option>
                                        <option value="1294">Studio Don Juan</option>
                                        <option value="409">Studio Egg</option>
                                        <option value="1521">Studio elle</option>
                                        <option value="423">Studio Eromatick</option>
                                        <option value="24">Studio Fantasia</option>
                                        <option value="93">Studio Flag</option>
                                        <option value="427">Studio G-1Neo</option>
                                        <option value="36">Studio Gallop</option>
                                        <option value="1227">Studio GDW</option>
                                        <option value="21">Studio Ghibli</option>
                                        <option value="418">Studio Gokumi</option>
                                        <option value="1253">Studio GOONEYS</option>
                                        <option value="497">Studio Gram</option>
                                        <option value="101">Studio Hibari</option>
                                        <option value="117">Studio Izena</option>
                                        <option value="829">Studio Jack</option>
                                        <option value="1375">Studio Jam</option>
                                        <option value="280">Studio Junio</option>
                                        <option value="937">Studio Kaab</option>
                                        <option value="272">Studio Kajino</option>
                                        <option value="909">Studio Kelmadick</option>
                                        <option value="256">Studio Kikan</option>
                                        <option value="1115">Studio Korumi</option>
                                        <option value="440">Studio Kuma</option>
                                        <option value="177">Studio Kyuuma</option>
                                        <option value="973">Studio Liberty</option>
                                        <option value="1383">Studio Live</option>
                                        <option value="1071">Studio Lotus</option>
                                        <option value="1505">Studio March</option>
                                        <option value="114">Studio Matrix</option>
                                        <option value="719">Studio Mausu</option>
                                        <option value="1426">Studio Meditation With a Pencil</option>
                                        <option value="1248">Studio Mirai</option>
                                        <option value="1155">Studio Moriken</option>
                                        <option value="487">Studio MWP</option>
                                        <option value="1059">Studio Nem</option>
                                        <option value="781">Studio NOIX</option>
                                        <option value="199">Studio Nue</option>
                                        <option value="299">Studio Pastoral</option>
                                        <option value="1">Studio Pierrot</option>
                                        <option value="1523">Studio Ponoc</option>
                                        <option value="443">Studio PuYUKAI</option>
                                        <option value="84">Studio Rikka</option>
                                        <option value="543">Studio Saki Makura</option>
                                        <option value="629">Studio Sign</option>
                                        <option value="438">Studio Signal</option>
                                        <option value="494">Studio Take Off</option>
                                        <option value="1352">Studio Ten Carat</option>
                                        <option value="216">Studio Tron</option>
                                        <option value="210">Studio Tulip</option>
                                        <option value="404">Studio Unicorn</option>
                                        <option value="1244">Studio VOLN</option>
                                        <option value="1533">Studio WHO</option>
                                        <option value="412">Studio Wombat</option>
                                        <option value="1509">Studio World</option>
                                        <option value="1504">Studio Z5</option>
                                        <option value="1089">Studio Zain</option>
                                        <option value="903">Studio Zealot</option>
                                        <option value="435">Studio Zero</option>
                                        <option value="1266">Studio! Cucuri</option>
                                        <option value="549">StudioRF Inc.</option>
                                        <option value="1608">SUBARU</option>
                                        <option value="1593">Success Co.</option>
                                        <option value="1348">Sugar Boy</option>
                                        <option value="1507">Sumitomo Corporation</option>
                                        <option value="1604">Sun TV</option>
                                        <option value="761">Sunny Side Up</option>
                                        <option value="14">Sunrise</option>
                                        <option value="1543">Sunrise Music Publishing</option>
                                        <option value="307">Sunwoo Entertainment</option>
                                        <option value="1364">Super Techno Arts</option>
                                        <option value="274">Suzuki Mirano</option>
                                        <option value="1474">Synch-Point</option>
                                        <option value="434">Synergy Japan</option>
                                        <option value="118">SynergySP</option>
                                        <option value="405">T-Rex</option>
                                        <option value="1015">T.O Entertainment</option>
                                        <option value="1371">T.P.O</option>
                                        <option value="1622">Tablier Communication</option>
                                        <option value="917">Takahashi Studio</option>
                                        <option value="327">Takara</option>
                                        <option value="1421">Takara Tomy A.R.T.S</option>
                                        <option value="332">Takeshobo</option>
                                        <option value="345">TAKI Corporation</option>
                                        <option value="939">Tama Production</option>
                                        <option value="388">Tamura Shigeru Studio</option>
                                        <option value="416">TAP</option>
                                        <option value="633">Tasogare Otome×Amnesia Production Partners</option>
                                        <option value="103">Tatsunoko Production</option>
                                        <option value="145">TBS</option>
                                        <option value="1283">TC Entertainment</option>
                                        <option value="489">TCJ</option>
                                        <option value="1335">TEAM Entertainment Inc.</option>
                                        <option value="1562">Team YokkyuFuman</option>
                                        <option value="949">teamKG</option>
                                        <option value="1499">Techno Sound</option>
                                        <option value="1223">Teichiku Entertainment</option>
                                        <option value="385">Tele-Cartoon Japan</option>
                                        <option value="94">Telecom Animation Film</option>
                                        <option value="358">Telescreen BV</option>
                                        <option value="1349">Tencent Animation</option>
                                        <option value="1617">Tencent Japan</option>
                                        <option value="1514">Tengu Kobo</option>
                                        <option value="200">Tezuka Productions</option>
                                        <option value="229">The Answer Studio</option>
                                        <option value="476">The Berich</option>
                                        <option value="1250">The National Film Center Japan</option>
                                        <option value="499">The Pokemon Company International</option>
                                        <option value="350">The Village of Marchen</option>
                                        <option value="273">Think Corporation</option>
                                        <option value="208">Three Fat Samurai</option>
                                        <option value="248">Tin House</option>
                                        <option value="73">TMS Entertainment</option>
                                        <option value="707">TMS-Kyokuchi</option>
                                        <option value="120">TNK</option>
                                        <option value="1558">TOCSIS</option>
                                        <option value="18">Toei Animation</option>
                                        <option value="141">Toei Video</option>
                                        <option value="245">Toho</option>
                                        <option value="1143">TOHO animation</option>
                                        <option value="577">Tohokushinsha Film Corporation</option>
                                        <option value="1455">Tokai Television</option>
                                        <option value="905">Tokuma Japan</option>
                                        <option value="1493">Tokuma Japan Communications</option>
                                        <option value="382">Tokuma Shoten</option>
                                        <option value="899">Tokyo Animation Film</option>
                                        <option value="1625">Tokyo FM Broadcasting CO., LTD</option>
                                        <option value="122">Tokyo Kids</option>
                                        <option value="403">Tokyo Media Connections</option>
                                        <option value="65">Tokyo movies.Movie Shinsha</option>
                                        <option value="1211">Tokyo MX</option>
                                        <option value="1319">Tokyo Theatres Company</option>
                                        <option value="1643">Tokyo University of the Arts</option>
                                        <option value="484">TOKYOPOP</option>
                                        <option value="1312">Tokyu Recreation</option>
                                        <option value="587">Tomason</option>
                                        <option value="1265">Tomovies</option>
                                        <option value="366">Tomoyasu Murata Company</option>
                                        <option value="1458">TOMY Company</option>
                                        <option value="1356">Tonko House</option>
                                        <option value="1637">Top-Insight International Co., LTD.</option>
                                        <option value="363">Topcraft</option>
                                        <option value="1620">Toppan Printing</option>
                                        <option value="882">Toranoana</option>
                                        <option value="1541">Tose</option>
                                        <option value="224">Toshiba EMI</option>
                                        <option value="741">Toshiba Entertainment</option>
                                        <option value="671">Toshima Entertainment</option>
                                        <option value="1390">Toy's Factory</option>
                                        <option value="80">Trans Arts</option>
                                        <option value="1316">Trans Cosmos</option>
                                        <option value="1165">Tri-Slash</option>
                                        <option value="110">Triangle Staff</option>
                                        <option value="384">Trick Block</option>
                                        <option value="803">Trigger</option>
                                        <option value="178">Trilogy Future Studio</option>
                                        <option value="63">Trinet Entertainment</option>
                                        <option value="643">Trinity Sound</option>
                                        <option value="860">Triple X</option>
                                        <option value="1103">TROYCA</option>
                                        <option value="901">Tsubasa Entertainment</option>
                                        <option value="453">Tsuburaya Productions</option>
                                        <option value="390">Tsuchida Productions</option>
                                        <option value="1638">Tsukimidou</option>
                                        <option value="653">tsuritama partners</option>
                                        <option value="1292">TUBA</option>
                                        <option value="1355">TV Aichi</option>
                                        <option value="55">TV Asahi</option>
                                        <option value="100">TV Osaka</option>
                                        <option value="1627">TV Saitama</option>
                                        <option value="1511">TV Setouchi</option>
                                        <option value="16">TV Tokyo</option>
                                        <option value="717">TV Tokyo Music</option>
                                        <option value="1650">Twilight Studio</option>
                                        <option value="1451">TYO</option>
                                        <option value="333">TYO Animations</option>
                                        <option value="1340">TYPHOON GRAPHICS</option>
                                        <option value="1583">U-NEXT</option>
                                        <option value="561">U/M/A/A Inc.</option>
                                        <option value="43">ufotable</option>
                                        <option value="539">Ultra Super Pictures</option>
                                        <option value="368">UM Productions</option>
                                        <option value="371">Union Cho</option>
                                        <option value="1397">Universal Music Japan</option>
                                        <option value="1450">Universal Pictures Japan</option>
                                        <option value="1031">Universal Radio Studio</option>
                                        <option value="507">Universal Studios</option>
                                        <option value="835">UNLIMITED Partners</option>
                                        <option value="1447">Urban Vision</option>
                                        <option value="472">Usagi.Ou</option>
                                        <option value="1615">USEN</option>
                                        <option value="265">Valkyria</option>
                                        <option value="29">VAP</option>
                                        <option value="945">Vasoon Animation</option>
                                        <option value="136">Vega Entertainment</option>
                                        <option value="457">Venet</option>
                                        <option value="212">Venus Vangard</option>
                                        <option value="123">Victor Entertainment</option>
                                        <option value="433">View Works</option>
                                        <option value="733">Viki</option>
                                        <option value="246">Visual 80</option>
                                        <option value="203">Visual Art's</option>
                                        <option value="1518">Visual Vision</option>
                                        <option value="119">Viz Media</option>
                                        <option value="655">Volks</option>
                                        <option value="1571">Voyager Entertainment</option>
                                        <option value="1396">W-Toon Studio</option>
                                        <option value="450">Wako Productions</option>
                                        <option value="1400">Walkers Company</option>
                                        <option value="417">Walt Disney Studios</option>
                                        <option value="318">WAO World</option>
                                        <option value="1537">Wargaming Japan</option>
                                        <option value="415">Warner Bros.</option>
                                        <option value="1011">Warner Music Japan</option>
                                        <option value="817">WField</option>
                                        <option value="1327">White Bear</option>
                                        <option value="314">White Fox</option>
                                        <option value="1596">Will Palette</option>
                                        <option value="858">Wit Studio</option>
                                        <option value="511">Wonder Kids</option>
                                        <option value="1648">World Cosplay Summit</option>
                                        <option value="33">WOWOW</option>
                                        <option value="27">Xebec</option>
                                        <option value="898">Xebec Zwei</option>
                                        <option value="1572">XFLAG</option>
                                        <option value="1573">XFLAG Pictures</option>
                                        <option value="1578">Xing</option>
                                        <option value="239">Y.O.U.C</option>
                                        <option value="795">Yahoo! Japan</option>
                                        <option value="1055">Yamamura Animation, Inc.</option>
                                        <option value="381">Yamato Works</option>
                                        <option value="1431">Yaoqi</option>
                                        <option value="1560">Yaoyorozu</option>
                                        <option value="308">Yellow Film</option>
                                        <option value="127">Yomiko Advertising</option>
                                        <option value="675">Yomiuri Advertising</option>
                                        <option value="76">Yomiuri Telecasting Corporation</option>
                                        <option value="1492">Yomiuri TV Enterprise</option>
                                        <option value="1453">Yoon's Color</option>
                                        <option value="220">Youmex</option>
                                        <option value="236">YTV</option>
                                        <option value="96">Yumeta Company</option>
                                        <option value="1392">Zack Promotion</option>
                                        <option value="1081">ZERO-A</option>
                                        <option value="1379">Zero-G</option>
                                        <option value="1131">Zero-G Room</option>
                                        <option value="218">Zexcs</option>
                                        <option value="1245">ZIZ Entertainment (ZIZ)</option>
                                        <option value="1376">ZOOM ENTERPRISE</option>
                                        <option value="557">Zyc</option>
                                    </select></td>
                                </tr>
                                <tr>
                                    <td>Rated</td>
                                    <td><select name="r" id="r" class="inputtext">
                                        <option selected="selected" value="0">Select rating</option>
                                        <option value="1">G - All Ages</option>
                                        <option value="2">PG - Children</option>
                                        <option value="3">PG-13 - Teens 13 or older</option>
                                        <option value="4">R - 17+ (violence &amp; profanity)</option>
                                        <option value="5">R+ - Mild Nudity</option>
                                        <option value="6">Rx - Hentai</option>
                                    </select></td>
                                </tr>
                                <tr>
                                    <td>Start Date</td>
                                    <td><select name="sm" id="sm" class="inputtext">
                                        <option selected="selected" value="0">-</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                        <option value="6">6</option>
                                        <option value="7">7</option>
                                        <option value="8">8</option>
                                        <option value="9">9</option>
                                        <option value="10">10</option>
                                        <option value="11">11</option>
                                        <option value="12">12</option>
                                    </select>
                                        -
                                        <select name="sd" id="sd" class="inputtext">
                                            <option selected="selected" value="0">-</option>
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                            <option value="6">6</option>
                                            <option value="7">7</option>
                                            <option value="8">8</option>
                                            <option value="9">9</option>
                                            <option value="10">10</option>
                                            <option value="11">11</option>
                                            <option value="12">12</option>
                                            <option value="13">13</option>
                                            <option value="14">14</option>
                                            <option value="15">15</option>
                                            <option value="16">16</option>
                                            <option value="17">17</option>
                                            <option value="18">18</option>
                                            <option value="19">19</option>
                                            <option value="20">20</option>
                                            <option value="21">21</option>
                                            <option value="22">22</option>
                                            <option value="23">23</option>
                                            <option value="24">24</option>
                                            <option value="25">25</option>
                                            <option value="26">26</option>
                                            <option value="27">27</option>
                                            <option value="28">28</option>
                                            <option value="29">29</option>
                                            <option value="30">30</option>
                                            <option value="31">31</option>
                                        </select>
                                        -
                                        <select name="sy" class="inputtext">
                                            <option value="0">-</option>
                                            <option value="2017">2017</option>
                                            <option value="2016">2016</option>
                                            <option value="2015">2015</option>
                                            <option value="2014">2014</option>
                                            <option value="2013">2013</option>
                                            <option value="2012">2012</option>
                                            <option value="2011">2011</option>
                                            <option value="2010">2010</option>
                                            <option value="2009">2009</option>
                                            <option value="2008">2008</option>
                                            <option value="2007">2007</option>
                                            <option value="2006">2006</option>
                                            <option value="2005">2005</option>
                                            <option value="2004">2004</option>
                                            <option value="2003">2003</option>
                                            <option value="2002">2002</option>
                                            <option value="2001">2001</option>
                                            <option value="2000">2000</option>
                                            <option value="1999">1999</option>
                                            <option value="1998">1998</option>
                                            <option value="1997">1997</option>
                                            <option value="1996">1996</option>
                                            <option value="1995">1995</option>
                                            <option value="1994">1994</option>
                                            <option value="1993">1993</option>
                                            <option value="1992">1992</option>
                                            <option value="1991">1991</option>
                                            <option value="1990">1990</option>
                                            <option value="1989">1989</option>
                                            <option value="1988">1988</option>
                                            <option value="1987">1987</option>
                                            <option value="1986">1986</option>
                                            <option value="1985">1985</option>
                                            <option value="1984">1984</option>
                                            <option value="1983">1983</option>
                                            <option value="1982">1982</option>
                                            <option value="1981">1981</option>
                                            <option value="1980">1980</option>
                                            <option value="1979">1979</option>
                                            <option value="1978">1978</option>
                                            <option value="1977">1977</option>
                                            <option value="1976">1976</option>
                                            <option value="1975">1975</option>
                                            <option value="1974">1974</option>
                                            <option value="1973">1973</option>
                                            <option value="1972">1972</option>
                                            <option value="1971">1971</option>
                                            <option value="1970">1970</option>
                                            <option value="1969">1969</option>
                                            <option value="1968">1968</option>
                                            <option value="1967">1967</option>
                                            <option value="1966">1966</option>
                                            <option value="1965">1965</option>
                                            <option value="1964">1964</option>
                                            <option value="1963">1963</option>
                                            <option value="1962">1962</option>
                                            <option value="1961">1961</option>
                                            <option value="1960">1960</option>
                                            <option value="1959">1959</option>
                                            <option value="1958">1958</option>
                                            <option value="1957">1957</option>
                                            <option value="1956">1956</option>
                                            <option value="1955">1955</option>
                                            <option value="1954">1954</option>
                                            <option value="1953">1953</option>
                                            <option value="1952">1952</option>
                                            <option value="1951">1951</option>
                                            <option value="1950">1950</option>
                                            <option value="1949">1949</option>
                                            <option value="1948">1948</option>
                                            <option value="1947">1947</option>
                                            <option value="1946">1946</option>
                                            <option value="1945">1945</option>
                                            <option value="1944">1944</option>
                                            <option value="1943">1943</option>
                                            <option value="1942">1942</option>
                                            <option value="1941">1941</option>
                                            <option value="1940">1940</option>
                                            <option value="1939">1939</option>
                                            <option value="1938">1938</option>
                                            <option value="1937">1937</option>
                                            <option value="1936">1936</option>
                                            <option value="1935">1935</option>
                                            <option value="1934">1934</option>
                                            <option value="1933">1933</option>
                                            <option value="1932">1932</option>
                                            <option value="1931">1931</option>
                                            <option value="1930">1930</option>
                                            <option value="1929">1929</option>
                                            <option value="1928">1928</option>
                                            <option value="1927">1927</option>
                                            <option value="1926">1926</option>
                                            <option value="1925">1925</option>
                                            <option value="1924">1924</option>
                                            <option value="1923">1923</option>
                                            <option value="1922">1922</option>
                                            <option value="1921">1921</option>
                                            <option value="1920">1920</option>
                                            <option value="1919">1919</option>
                                            <option value="1918">1918</option>
                                            <option value="1917">1917</option>
                                        </select>
                                        <small>mm-dd-yyyy</small>
                                    </td>
                                </tr>
                                <tr>
                                    <td>End Date</td>
                                    <td><select name="em" id="em" class="inputtext">
                                        <option selected="selected" value="0">-</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                        <option value="6">6</option>
                                        <option value="7">7</option>
                                        <option value="8">8</option>
                                        <option value="9">9</option>
                                        <option value="10">10</option>
                                        <option value="11">11</option>
                                        <option value="12">12</option>
                                    </select>
                                        -
                                        <select name="ed" id="ed" class="inputtext">
                                            <option selected="selected" value="0">-</option>
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                            <option value="6">6</option>
                                            <option value="7">7</option>
                                            <option value="8">8</option>
                                            <option value="9">9</option>
                                            <option value="10">10</option>
                                            <option value="11">11</option>
                                            <option value="12">12</option>
                                            <option value="13">13</option>
                                            <option value="14">14</option>
                                            <option value="15">15</option>
                                            <option value="16">16</option>
                                            <option value="17">17</option>
                                            <option value="18">18</option>
                                            <option value="19">19</option>
                                            <option value="20">20</option>
                                            <option value="21">21</option>
                                            <option value="22">22</option>
                                            <option value="23">23</option>
                                            <option value="24">24</option>
                                            <option value="25">25</option>
                                            <option value="26">26</option>
                                            <option value="27">27</option>
                                            <option value="28">28</option>
                                            <option value="29">29</option>
                                            <option value="30">30</option>
                                            <option value="31">31</option>
                                        </select>
                                        -
                                        <select name="ey" class="inputtext">
                                            <option value="0">-</option>
                                            <option value="2017">2017</option>
                                            <option value="2016">2016</option>
                                            <option value="2015">2015</option>
                                            <option value="2014">2014</option>
                                            <option value="2013">2013</option>
                                            <option value="2012">2012</option>
                                            <option value="2011">2011</option>
                                            <option value="2010">2010</option>
                                            <option value="2009">2009</option>
                                            <option value="2008">2008</option>
                                            <option value="2007">2007</option>
                                            <option value="2006">2006</option>
                                            <option value="2005">2005</option>
                                            <option value="2004">2004</option>
                                            <option value="2003">2003</option>
                                            <option value="2002">2002</option>
                                            <option value="2001">2001</option>
                                            <option value="2000">2000</option>
                                            <option value="1999">1999</option>
                                            <option value="1998">1998</option>
                                            <option value="1997">1997</option>
                                            <option value="1996">1996</option>
                                            <option value="1995">1995</option>
                                            <option value="1994">1994</option>
                                            <option value="1993">1993</option>
                                            <option value="1992">1992</option>
                                            <option value="1991">1991</option>
                                            <option value="1990">1990</option>
                                            <option value="1989">1989</option>
                                            <option value="1988">1988</option>
                                            <option value="1987">1987</option>
                                            <option value="1986">1986</option>
                                            <option value="1985">1985</option>
                                            <option value="1984">1984</option>
                                            <option value="1983">1983</option>
                                            <option value="1982">1982</option>
                                            <option value="1981">1981</option>
                                            <option value="1980">1980</option>
                                            <option value="1979">1979</option>
                                            <option value="1978">1978</option>
                                            <option value="1977">1977</option>
                                            <option value="1976">1976</option>
                                            <option value="1975">1975</option>
                                            <option value="1974">1974</option>
                                            <option value="1973">1973</option>
                                            <option value="1972">1972</option>
                                            <option value="1971">1971</option>
                                            <option value="1970">1970</option>
                                            <option value="1969">1969</option>
                                            <option value="1968">1968</option>
                                            <option value="1967">1967</option>
                                            <option value="1966">1966</option>
                                            <option value="1965">1965</option>
                                            <option value="1964">1964</option>
                                            <option value="1963">1963</option>
                                            <option value="1962">1962</option>
                                            <option value="1961">1961</option>
                                            <option value="1960">1960</option>
                                            <option value="1959">1959</option>
                                            <option value="1958">1958</option>
                                            <option value="1957">1957</option>
                                            <option value="1956">1956</option>
                                            <option value="1955">1955</option>
                                            <option value="1954">1954</option>
                                            <option value="1953">1953</option>
                                            <option value="1952">1952</option>
                                            <option value="1951">1951</option>
                                            <option value="1950">1950</option>
                                            <option value="1949">1949</option>
                                            <option value="1948">1948</option>
                                            <option value="1947">1947</option>
                                            <option value="1946">1946</option>
                                            <option value="1945">1945</option>
                                            <option value="1944">1944</option>
                                            <option value="1943">1943</option>
                                            <option value="1942">1942</option>
                                            <option value="1941">1941</option>
                                            <option value="1940">1940</option>
                                            <option value="1939">1939</option>
                                            <option value="1938">1938</option>
                                            <option value="1937">1937</option>
                                            <option value="1936">1936</option>
                                            <option value="1935">1935</option>
                                            <option value="1934">1934</option>
                                            <option value="1933">1933</option>
                                            <option value="1932">1932</option>
                                            <option value="1931">1931</option>
                                            <option value="1930">1930</option>
                                            <option value="1929">1929</option>
                                            <option value="1928">1928</option>
                                            <option value="1927">1927</option>
                                            <option value="1926">1926</option>
                                            <option value="1925">1925</option>
                                            <option value="1924">1924</option>
                                            <option value="1923">1923</option>
                                            <option value="1922">1922</option>
                                            <option value="1921">1921</option>
                                            <option value="1920">1920</option>
                                            <option value="1919">1919</option>
                                            <option value="1918">1918</option>
                                            <option value="1917">1917</option>
                                        </select>
                                        <small>mm-dd-yyyy</small>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">Columns</td>
                                    <td><select multiple="multiple" name="c[]" size="5" class="inputtext">
                                        <option value="a" selected="selected">Type</option>
                                        <option value="b" selected="selected">Eps</option>
                                        <option value="c" selected="selected">Score</option>
                                        <option value="d">Start Date</option>
                                        <option value="e">End Date</option>
                                        <option value="f" selected="selected">Total Members</option>
                                        <option value="g">Rating</option>
                                    </select></td>
                                </tr>
                                </tbody>
                            </table>
                            <div class="fs12 fw-b mt24 mb8">
                                Genre Filter
                                <a href="javascript:void(0);"
                                   onclick="window.open('https://myanimelist.net/info.php?go=genre','infoWindow','menubar=no,scrollbars=yes,status=no,width=300,height=400');"
                                   class="fs10 fw-n">More Info</a></div>
                            <div class="spaceit_pad"><select name="gx" id="gx">
                                <option selected="selected" value="0">Include genres selected</option>
                                <option value="1">Exclude genres selected</option>
                            </select></div>
                            <table border="0" cellpadding="1" cellspacing="0" width="100%" class="space_table">
                                <tbody>
                                <tr>
                                    <td><input id="genre-1" name="genre[]" type="checkbox" value="1"><label
                                            for="genre-1" id="label_for_genre-1">Action</label></td>
                                    <td><input id="genre-2" name="genre[]" type="checkbox" value="2"><label
                                            for="genre-2" id="label_for_genre-2">Adventure</label></td>
                                    <td><input id="genre-3" name="genre[]" type="checkbox" value="3"><label
                                            for="genre-3" id="label_for_genre-3">Cars</label></td>
                                    <td><input id="genre-4" name="genre[]" type="checkbox" value="4"><label
                                            for="genre-4" id="label_for_genre-4">Comedy</label></td>
                                    <td><input id="genre-5" name="genre[]" type="checkbox" value="5"><label
                                            for="genre-5" id="label_for_genre-5">Dementia</label></td>
                                    <td><input id="genre-6" name="genre[]" type="checkbox" value="6"><label
                                            for="genre-6" id="label_for_genre-6">Demons</label></td>
                                    <td><input id="genre-7" name="genre[]" type="checkbox" value="7"><label
                                            for="genre-7" id="label_for_genre-7">Mystery</label></td>
                                    <td><input id="genre-8" name="genre[]" type="checkbox" value="8"><label
                                            for="genre-8" id="label_for_genre-8">Drama</label></td>
                                </tr>
                                <tr>
                                    <td><input id="genre-9" name="genre[]" type="checkbox" value="9"><label
                                            for="genre-9" id="label_for_genre-9">Ecchi</label></td>
                                    <td><input id="genre-10" name="genre[]" type="checkbox" value="10"><label
                                            for="genre-10" id="label_for_genre-10">Fantasy</label></td>
                                    <td><input id="genre-11" name="genre[]" type="checkbox" value="11"><label
                                            for="genre-11" id="label_for_genre-11">Game</label></td>
                                    <td><input id="genre-12" name="genre[]" type="checkbox" value="12"><label
                                            for="genre-12" id="label_for_genre-12">Hentai</label></td>
                                    <td><input id="genre-13" name="genre[]" type="checkbox" value="13"><label
                                            for="genre-13" id="label_for_genre-13">Historical</label></td>
                                    <td><input id="genre-14" name="genre[]" type="checkbox" value="14"><label
                                            for="genre-14" id="label_for_genre-14">Horror</label></td>
                                    <td><input id="genre-15" name="genre[]" type="checkbox" value="15"><label
                                            for="genre-15" id="label_for_genre-15">Kids</label></td>
                                    <td><input id="genre-16" name="genre[]" type="checkbox" value="16"><label
                                            for="genre-16" id="label_for_genre-16">Magic</label></td>
                                </tr>
                                <tr>
                                    <td><input id="genre-17" name="genre[]" type="checkbox" value="17"><label
                                            for="genre-17" id="label_for_genre-17">Martial Arts</label></td>
                                    <td><input id="genre-18" name="genre[]" type="checkbox" value="18"><label
                                            for="genre-18" id="label_for_genre-18">Mecha</label></td>
                                    <td><input id="genre-19" name="genre[]" type="checkbox" value="19"><label
                                            for="genre-19" id="label_for_genre-19">Music</label></td>
                                    <td><input id="genre-20" name="genre[]" type="checkbox" value="20"><label
                                            for="genre-20" id="label_for_genre-20">Parody</label></td>
                                    <td><input id="genre-21" name="genre[]" type="checkbox" value="21"><label
                                            for="genre-21" id="label_for_genre-21">Samurai</label></td>
                                    <td><input id="genre-22" name="genre[]" type="checkbox" value="22"><label
                                            for="genre-22" id="label_for_genre-22">Romance</label></td>
                                    <td><input id="genre-23" name="genre[]" type="checkbox" value="23"><label
                                            for="genre-23" id="label_for_genre-23">School</label></td>
                                    <td><input id="genre-24" name="genre[]" type="checkbox" value="24"><label
                                            for="genre-24" id="label_for_genre-24">Sci-Fi</label></td>
                                </tr>
                                <tr>
                                    <td><input id="genre-25" name="genre[]" type="checkbox" value="25"><label
                                            for="genre-25" id="label_for_genre-25">Shoujo</label></td>
                                    <td><input id="genre-26" name="genre[]" type="checkbox" value="26"><label
                                            for="genre-26" id="label_for_genre-26">Shoujo Ai</label></td>
                                    <td><input id="genre-27" name="genre[]" type="checkbox" value="27"><label
                                            for="genre-27" id="label_for_genre-27">Shounen</label></td>
                                    <td><input id="genre-28" name="genre[]" type="checkbox" value="28"><label
                                            for="genre-28" id="label_for_genre-28">Shounen Ai</label></td>
                                    <td><input id="genre-29" name="genre[]" type="checkbox" value="29"><label
                                            for="genre-29" id="label_for_genre-29">Space</label></td>
                                    <td><input id="genre-30" name="genre[]" type="checkbox" value="30"><label
                                            for="genre-30" id="label_for_genre-30">Sports</label></td>
                                    <td><input id="genre-31" name="genre[]" type="checkbox" value="31"><label
                                            for="genre-31" id="label_for_genre-31">Super Power</label></td>
                                    <td><input id="genre-32" name="genre[]" type="checkbox" value="32"><label
                                            for="genre-32" id="label_for_genre-32">Vampire</label></td>
                                </tr>
                                <tr>
                                    <td><input id="genre-33" name="genre[]" type="checkbox" value="33"><label
                                            for="genre-33" id="label_for_genre-33">Yaoi</label></td>
                                    <td><input id="genre-34" name="genre[]" type="checkbox" value="34"><label
                                            for="genre-34" id="label_for_genre-34">Yuri</label></td>
                                    <td><input id="genre-35" name="genre[]" type="checkbox" value="35"><label
                                            for="genre-35" id="label_for_genre-35">Harem</label></td>
                                    <td><input id="genre-36" name="genre[]" type="checkbox" value="36"><label
                                            for="genre-36" id="label_for_genre-36">Slice of Life</label></td>
                                    <td><input id="genre-37" name="genre[]" type="checkbox" value="37"><label
                                            for="genre-37" id="label_for_genre-37">Supernatural</label></td>
                                    <td><input id="genre-38" name="genre[]" type="checkbox" value="38"><label
                                            for="genre-38" id="label_for_genre-38">Military</label></td>
                                    <td><input id="genre-39" name="genre[]" type="checkbox" value="39"><label
                                            for="genre-39" id="label_for_genre-39">Police</label></td>
                                    <td><input id="genre-40" name="genre[]" type="checkbox" value="40"><label
                                            for="genre-40" id="label_for_genre-40">Psychological</label></td>
                                </tr>
                                <tr>
                                    <td><input id="genre-41" name="genre[]" type="checkbox" value="41"><label
                                            for="genre-41" id="label_for_genre-41">Thriller</label></td>
                                    <td><input id="genre-42" name="genre[]" type="checkbox" value="42"><label
                                            for="genre-42" id="label_for_genre-42">Seinen</label></td>
                                    <td><input id="genre-43" name="genre[]" type="checkbox" value="43"><label
                                            for="genre-43" id="label_for_genre-43">Josei</label></td>
                                </tr>
                                </tbody>
                            </table>
                            <div class="mt8 mb24 pb16 ac"><input type="submit" value="Search"
                                                                 class="inputButton btn-form-submit notActive"></div>
                        </div>
                    </form>

                </div>
                <script language="javascript" type="text/javascript">
                    function search_animeSearchLoad() {
                        var titleObj = document.getElementById("q");
                        titleObj.focus();
                    }

                    function search_showAdvanced() {
                        $("#advancedSearch").toggle();
                    }
                </script>

                <div class="anime-manga-search pb24">
                    <div class="normal_header pt24 mb0">Genres</div>
                    <div class="genre-link">
                        <%
                            Class.forName("com.mysql.jdbc.Driver").newInstance();
                            Connection connection =
                                    DriverManager.getConnection("jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false", "root", "Apple07");
                            Statement select = connection.createStatement();
                            ResultSet result = select.executeQuery("select *  from genres; ");
                            int col = 0;
                            out.println("<div class=\"genre-list-col\">");

                            while (result.next()){
                                if (col % 5 == 0) {
                                    out.println("</div>");
                                    out.println("<div class=\"genre-list-col\">");
                                }
                                String genre = result.getString("name");
                                out.println("<div class=\"genre-list al\">");
                                out.println("<a href = '/servlet/MovieList?movieGenre=" + genre + "' class=\"genre-name-link\">" + genre + "</a>");
                                out.println("</div>");
                                col++;
                            }
                            out.println("</div>");

                            result.close();
                            select.close();

                        %>
                        </div>
                    </div>

                </div>

            </div><!-- end of contentHome -->
        </div><!-- end of contentWrapper -->

        <!--  control container height -->
        <div style="clear:both;"></div>

        <!-- end rightbody -->

    </div><!-- wrapper -->


    <div id="ad-skin-bg-right" class="ad-skin-side-outer ad-skin-side-bg bg-right">
        <div id="ad-skin-right" class="ad-skin-side right" style="display: none;">
            <div id="ad-skin-right-absolute-block">
                <div id="ad-skin-right-fixed-block"></div>
            </div>
        </div>
    </div>
</div><!-- #myanimelist -->

<script>
    var header = {
        alphabet: "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    };

    function makeUL(string) {
        var list = document.createElement('ul');

        for (var i = 0; i < string.length; i++) {
            var item = document.createElement('li');
            var link = document.createElement('a');
            link.innerHTML = string.charAt(i);
            link.href = '/servlet/MovieList?movieTitle=' + string.charAt(i);

            item.appendChild(link);
            list.appendChild(item);
        }

        return list;
    }
    document.getElementById('horiznav_nav').appendChild(makeUL(header.alphabet));
</script>
</body>
</html>