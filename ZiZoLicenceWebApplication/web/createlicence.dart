import 'loginfunctions.dart';
import 'dart:js';
import 'dart:html';
import 'licenceserverrequest.dart';

String licenceLength;
String defaultDate = today(3);

void main()
{
  setlogOut();
  disableDateLengthTextBox();
  createDefaultDate();
  setDefaultIpAddress();
  setRadioButtons();
  listenToRadioButtons();
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#default_submitButton").onClick.listen(submitForm);
  querySelector("#specifiedLength").onClick.listen(checkDateValue);
  querySelector("#filter").onChange.listen(checkFilter);
}

setlogOut()
{
  var log = new LoginAndOut();
  querySelector("#logoutButton").onClick.listen(log.logout);
}

disableDateLengthTextBox()
{
  InputElement specifiedLengthTextbox = querySelector("#specifiedLength");
  specifiedLengthTextbox.disabled = true;
}

createDefaultDate()
{
  DateInputElement date = querySelector("#specifiedLength"); 
  date.value = today(3);
}

setDefaultIpAddress()
{
  InputElement ipAddress = querySelector("#url");
  ipAddress.value = window.location.host;
}

listenToRadioButtons()
{
  querySelector("#thirtyDays").onChange.listen(createThirtyDayLicence);
  querySelector("#neverExpires").onChange.listen(createUnlimitedLicence);
  querySelector("#specified").onChange.listen(createUserSpecifiedLicence);
}

createThirtyDayLicence(Event e)
{ 
  createDefaultDate();
  thirtyDayDate();
  disableTextbox(e);
}

createUnlimitedLicence(Event e)
{
  createDefaultDate();
  OutputElement unlimited = querySelector("#expiryDate");
  unlimited.value = "";
  disableTextbox(e);
}

createUserSpecifiedLicence(Event e)
{
  enableTextbox(e);
  DateInputElement i = querySelector("#specifiedLength");
  OutputElement specified = querySelector("#expiryDate");
  specified.value = "";
  licenceLength = i.value;
}

enableTextbox(Event e)
{
  InputElement specifiedLengthTextbox = querySelector("#specifiedLength");
  specifiedLengthTextbox.disabled = false;
}

disableTextbox(Event e)
{
  InputElement specifiedLengthTextbox = querySelector("#specifiedLength");
  specifiedLengthTextbox.disabled = true;
}

void submitForm(MouseEvent e)
{
  DateInputElement dateInput = querySelector("#specifiedLength");
  DateTime shortDate = dateInput.valueAsDate;
  InputElement un = querySelector("#username");
  InputElement fe = querySelector("#filter");
  InputElement url = querySelector("#url");
  String userValue;

  if (un.value.length==0)
    return;
  if (!hasButtonSet())
    return;
  
  userValue = un.value;
  if (url.value.length>0)
    userValue = userValue+"("+url.value+")";
  
  LicenceServerRequest.addLicence(
      userValue,shortDateFormat(shortDate),fe.value,
      window.sessionStorage['username'],window.sessionStorage['password'],
      "localhost",(s) => window.alert(s),(s) => window.alert("fail: "+s));
}

String shortDateFormat(DateTime date)
{
  String s = date.toIso8601String();
  return s.substring(0,10);
}

checkFilter(Event e)
{
  InputElement filter = querySelector("#filter");
  
  if(filter != "" || filter != "someFilter")
  
    filter.setCustomValidity("The Filter Does Not Exist, Please Enter A Valid Filter Option.");
  else
    filter.setCustomValidity("");
}

void processForm()
{
  
}

String licenceLengthChoice()
{
  if((querySelector("#thirtyDays") as RadioButtonInputElement).checked)
    return "The Licence Lasts For Thirty Days, Ending On: "+licenceLength+".";
  else if((querySelector("#neverExpires") as RadioButtonInputElement).checked)
    return "The Licence Has An Unlimited Length, The Licence Does Not Have An Expiration Date.";
  else if((querySelector("#specified") as RadioButtonInputElement).checked)
    return "The Licence Length Has A User Specified Length, Ending On: "+chosenDate()+".";
  else
    return "";
}

String today(int days)
{
  DateTime baseDate = new DateTime.now();
  DateTime minDate = baseDate.add(new Duration(days: days));
  String baseDateString = minDate.toString();
  String finalDate = baseDateString.substring(0,10);
  return finalDate;
}

String chosenDate()
{
  DateInputElement date = querySelector("#specifiedLength");
  String baseChoice = date.value;
  String dateChoice = baseChoice.split("-").reversed.join("-");
  return dateChoice;
}

void thirtyDayDate()
{
  DateTime baseDate = new DateTime.now();
  DateTime licenceDate = baseDate.add(new Duration(days: 30));
  String date = licenceDate.toString();
  String shortDate = date.substring(0,10);
  String printedDate = shortDate.split("-").reversed.join("-");
  OutputElement thirtyDays = querySelector("#expiryDate");
  thirtyDays.value = "The Licence Will Expire On: "+printedDate; 
  licenceLength = thirtyDays.value;
}

void setRadioButtons()
{
  (querySelector("#thirtyDays") as RadioButtonInputElement).checked = false;
  (querySelector("#neverExpires") as RadioButtonInputElement).checked = false;
  (querySelector("#specified") as RadioButtonInputElement).checked = false;
}

bool hasButtonSet()
{
  return (querySelector("#thirtyDays") as RadioButtonInputElement).checked ||
  (querySelector("#neverExpires") as RadioButtonInputElement).checked ||
  (querySelector("#specified") as RadioButtonInputElement).checked;
}

checkDateValue(Event e)
{
  DateInputElement dateInput = querySelector("#specifiedLength");
  DateTime shortDate = dateInput.valueAsDate;
  DateTime now = new DateTime.now();
  int day = now.day+2;
  DateTime nowWithoutTime = new DateTime(now.year,now.month,now.day,1,0,0,0);
  DateTime nowPlusThree = new DateTime(now.year,now.month,day,1,0,0,0);
  
  if(shortDate == nowWithoutTime)
    dateInput.setCustomValidity("Invalid Date : Licence Cannot Expire On Current Day");
  else if(shortDate == null)
    dateInput.setCustomValidity("Please Enter A Date");
  else if(!(shortDate.isAfter(nowWithoutTime)))
    dateInput.setCustomValidity("Invalid Date: Licence Cannot Be Set Before Current Day");
  else if(!(shortDate.isAfter(nowPlusThree)))
    dateInput.setCustomValidity("Invalid Date: Licence Must Have Minimum Length Of Three Days");
  else
    dateInput.setCustomValidity("");
}
