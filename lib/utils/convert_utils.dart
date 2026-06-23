
import 'package:intl/intl.dart';

class ConvertUtils{

  static String getTimeDiff(String date) {

    DateTime dateTime=DateTime.now();
    DateTime usaTime=dateTime.subtract(Duration(hours: 9,minutes: 30));

    // Define the specific date
    final targetDate = DateTime.parse(date);

    // Calculate the difference
    final difference = usaTime.difference(targetDate);

    // Extract different time units
    final seconds = difference.inSeconds;
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;
    final weeks = (days / 7).floor();
    final months = (days / 30).floor(); // Approximate month length
    final years = (days / 365).floor(); // Approximate year length

    // Create result string
    String result;
    if (years > 0) {
      result = '${years} year${years > 1 ? 's' : ''} ago';
    } else if (months > 0) result = '$months month${months > 1 ? 's' : ''} ago';
    else if (weeks > 0) result = '${weeks} week${weeks > 1 ? 's' : ''} ago';
    else if (days > 0) result = '${days} day${days > 1 ? 's' : ''} ago';
    else if (hours > 0) result = '${hours} hour${hours > 1 ? 's' : ''} ago';
    else if (minutes > 0) result = '${minutes} minute${minutes > 1 ? 's' : ''} ago';
    else result = '${seconds} second${seconds > 1 ? 's' : ''} ago';

    return result;
  }

  static String formatNumber(int number) {
    String formattedNumber;

    if (number >= 1000000000000) {
      // Trillions
      formattedNumber = '${(number / 1000000000000).toStringAsFixed(1)}T';
    } else if (number >= 1000000000) {
      // Billions
      formattedNumber = '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      // Millions
      formattedNumber = '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      // Thousands
      formattedNumber = '${(number / 1000).toStringAsFixed(1)}k';
    } else {
      // Less than 1,000
      return number.toString();
    }

    // Remove trailing .0
    return formattedNumber.contains('.0')
        ? formattedNumber.replaceAll('.0', '')
        : formattedNumber;
    return "${formattedNumber.replaceAll(RegExp(r'\.0+$'), '')}${formattedNumber.contains('.') ? '' : ''}";
  }



  static String getRelativeTime(String timestamp1, int timestamp2) {
    DateTime later = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp1) * 1000, isUtc: true);
    DateTime earlier = DateTime.fromMillisecondsSinceEpoch(timestamp2 * 1000, isUtc: true);
    Duration difference = earlier.difference(later);

    // Extract different time units
    final seconds = difference.inSeconds;
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;
    final weeks = (days / 7).floor();
    final months = (days / 30).floor(); // Approximate month length
    final years = (days / 365).floor(); // Approximate year length

    String result;

    if (years > 0) {
      result = '${years} year${years > 1 ? 's' : ''} ago';
    } else if (months > 0) {
      result = '${months} month${months > 1 ? 's' : ''} ago';
    } else if (weeks > 0) {
      result = '${weeks} week${weeks > 1 ? 's' : ''} ago';
    } else if (days > 0) {
      result = '${days} day${days > 1 ? 's' : ''} ago';
    } else if (hours > 0) {
      result = '${hours} hour${hours > 1 ? 's' : ''} ago';
    } else if (minutes > 0) {
      result = '${minutes} minute${minutes > 1 ? 's' : ''} ago';
    } else {
      result = '${seconds} second${seconds > 1 ? 's' : ''} ago';
    }

    return result;
  }

  static String formatCommaNumber(int number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }

  static Map<String, dynamic> filterLinks(String text) {
    // Regular expression to match various social media URLs
    final regex = RegExp(
      r'https?:\/\/(www\.)?(instagram\.com|youtube\.com|youtu\.be|tiktok\.com|facebook\.com|x\.com|threads\.net)[^\s]*',
      caseSensitive: false,
    );

    // Find all matches
    final matches = regex.allMatches(text);

    // Create a list of links
    List<String> links = matches.map((match) => match.group(0)!).toList();

    // Remove the links from the original text
    String filteredText = text.replaceAll(regex, '').replaceAll(RegExp(r'\s+'), ' ').trim();

    return {
      'text': filteredText,
      'links': links,
    };
  }

}