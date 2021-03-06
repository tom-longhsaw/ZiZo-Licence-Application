library licenceserver;

import 'soaprequest.dart';
import 'dart:html';

class LicenceServerRequest extends SoapRequest
{
  static void checkAdminLogin(String name,String password,String host,Function onPass,Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("checkAdminLogin");
    result.addArgument(name);
    result.addArgument(password);
    result.getStringResult((s) => (s=="true")? onPass() : onFail ());
  }
  
  static void addLicence(String user,String date,String filter,String adminName,String password,
                         String host,Function onPass,Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("addLicence");
    result.addArgument(user);
    result.addArgument(date);
    result.addArgument(filter);
    result.addArgument(adminName);
    result.addArgument(password);
    result.getStringResult((String s) => (s.contains("-"))? onPass(s) : onFail (s));
  }
  
  static void regenerateLicence(String licenceId, String adminName, String adminPassword, String host, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("regenerateProductKeyFor");
    result.addArgument(licenceId);
    result.addArgument(adminName);
    result.addArgument(adminPassword);
    result.getStringResult((String s) => (s.contains("-"))? onPass(s) : onFail(s));
  }
  
  static void addAdminUser(String user, String password, String adminName, String adminPassword, String host, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("perform");
    result.addArgument("add-user "+user+","+password);
    result.addArgument(adminName);
    result.addArgument(adminPassword);
    result.getStringResult((String s) => (s == "done")? onPass(s) : onFail(s));
  }
  
  static void changeAdminPassword(String user, String newPassword, String adminName, String adminPassword, String host, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("perform");
    result.addArgument("change-password "+user+","+newPassword);
    result.addArgument(adminName);
    result.addArgument(adminPassword);
    result.getStringResult((String s) => (s == "done")? onPass(s) : onFail(s));
  }
  
  static void removeUser(String user, String adminName, String adminPassword, String host, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("perform");
    result.addArgument("delete-user "+user);
    result.addArgument(adminName);
    result.addArgument(adminPassword);
    result.getStringResult((String s) => (s == "done")? onPass(s) : onFail(s));
  }
  
  static void removeLicence(String licenceKey, String adminName, String adminPassword, String host, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("removeLicence");
    result.addArgument(licenceKey);
    result.addArgument(adminName);
    result.addArgument(adminPassword);
    result.getStringResult((String s) => (s == "done")? onPass(s) : onFail(s));
  }
  
  static void searchForLicences(String searchCriteria, String adminName, String adminPassword, String host, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("licencesFor");
    result.addArgument(searchCriteria);
    result.addArgument(adminName);
    result.addArgument(adminPassword);
    result.getStringResult((String s) => (s.contains("key"))? onPass(s) : onFail(s));
  }
  
  static void addPermission(String user, String permissionChoice, String adminName, String adminPassword, String host, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("perform");
    result.addArgument("add-permission "+user+","+permissionChoice);
    result.addArgument(adminName);
    result.addArgument(adminPassword); 
    result.getStringResult((String s) => (s == "done")? onPass(s) : onFail(s));
  }
  
  static void checkPermissions(String adminName,String adminPassword,String host,Function action)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("getPermissions");
    result.addArgument(adminName);
    result.addArgument(adminPassword);
    result.getStringResult(action);
  }
  
  @override
  namespace()
  {
    return "licence.zizo.decsim.com";
  }
  
  String path()
  {
    return "DataReLicenceServer/LicenceServer";
  }
  
  static String defaultUri()
  {
    return window.location.host;
  }
    
}