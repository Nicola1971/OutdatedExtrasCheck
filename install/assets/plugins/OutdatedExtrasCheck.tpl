/**
 * OutdatedExtrasCheck
 *
 * Check Outdated bundled extras
 *
 * @author      Author: Nicola Lambathakis http://www.tattoocms.it/
 * @category	plugin
 * @version     0.1
 * @internal    @events OnManagerWelcomePrerender
 * @internal	@modx_category Manager
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @properties &wdgVisibility=Show widget for:;menu;All,AdminOnly,AdminExcluded,ThisRoleOnly,ThisUserOnly;All &ThisRole=Run only for this role:;string;;;(role id) &ThisUser=Run only for this user:;string;;;(username) &DittoVersion=Min Ditto version:;string;2.1.3 &MtvVersion=Min multiTV version:;string;2.0.12
 * @internal @installset base, sample
 * @internal    @disabled 0
 * @reportissues https://github.com/Nicola1971/OutdatedExtrasCheck/issues
 * @lastupdate  24-01-2018
 */
// get manager role check
$internalKey = $modx->getLoginUserID();
$sid = $modx->sid;
$role = $_SESSION['mgrRole'];
$user = $_SESSION['mgrShortname'];
// show widget only to Admin role 1
if(($role!=1) AND ($wdgVisibility == 'AdminOnly')) {}
// show widget to all manager users excluded Admin role 1
else if(($role==1) AND ($wdgVisibility == 'AdminExcluded')) {}
// show widget only to "this" role id
else if(($role!=$ThisRole) AND ($wdgVisibility == 'ThisRoleOnly')) {}
// show widget only to "this" username
else if(($user!=$ThisUser) AND ($wdgVisibility == 'ThisUserOnly')) {}
else {
//run the plugin
global $modx;
//function to extract snippet version from description <strong></strong> tags 
if (!function_exists('getver')) {
function getver($string, $tag)
{
$content ="/<$tag>(.*?)<\/$tag>/";
preg_match($content, $string, $text);
return $text[1];
	}
}
$e = &$modx->Event;
$EVOversion = $modx->config['settings_version'];
$output = '';
$table = $modx->getFullTableName('site_snippets');
//check ditto
//get min version from config
$minDittoVersion = $DittoVersion;
//search the snippet by name
$CheckDitto = $modx->db->select( "id, name, description", $table, "name='Ditto'" );
if($CheckDitto != ''){
while( $row = $modx->db->getRow( $CheckDitto ) ) {
//extract snippet version from description <strong></strong> tags 
$curr_ditto_version = getver($row['description'],"strong");
//check snippet version and return an alert if outdated
if ($version < $minDittoVersion){
$output .= '<div class="widget-wrapper alert alert-warning"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> <b>' . $row['name'] . '</b> snippet (version ' . $curr_ditto_version . ') is <b>outdated</b> and no more compatible with <b>Evolution '.$EVOversion.'.</b>. Please update <b>' . $row['name'] . '</b> to the latest version (min required '.$minDittoVersion.') from <a href="index.php?a=112&id=2">Extras</a> Module or move to <b>DocLister</b></div>';
		}
	}
} 
//end check ditto

//check Multitv
//get min version from config
$minMtvVersion = $MtvVersion;
//search the snippet by name
$CheckMtv = $modx->db->select( "id, name, description", $table, "name='multiTV'" );
if($CheckMtv != ''){
while( $row = $modx->db->getRow( $CheckMtv ) ) {
//extract snippet version from description <strong></strong> tags 
$curr_mtv_version = getver($row['description'],"strong");
//check snippet version and return an alert if outdated
if ($version < $minMtvVersion){
$output .= '<div class="widget-wrapper alert alert-warning"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> <b>' . $row['name'] . '</b> snippet (version ' . $curr_mtv_version . ') is <b>outdated</b> and no more compatible with <b>Evolution '.$EVOversion.'.</b>. Please update <b>' . $row['name'] . '</b> to the latest version (min required '.$minMtvVersion.') from <a href="index.php?a=112&id=2">Extras</a> Module</div>';
		}
	}
} 
//end check ditto
	
if($e->name == 'OnManagerWelcomePrerender') {
$out = $output;
$e->output($out);
return;
	}
}