package io.spring.application;

import io.spring.application.data.HolidayData;
import java.util.TreeMap;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.springframework.stereotype.Service;

@Service
public class HolidayQueryService {

  public HolidayData findNextHoliday() {
    return findNextHoliday(new DateTime());
  }

  public HolidayData findNextHoliday(DateTime referenceDate) {
    TreeMap<DateTime, String> holidays = getHolidaysForCurrentYear(referenceDate);

    holidays.putAll(getHolidaysForYear(referenceDate.getYear() + 1));

    DateTime nextHolidayDate = null;
    String nextHolidayName = null;

    for (DateTime date : holidays.keySet()) {
      if (date.isAfter(referenceDate)) {
        nextHolidayDate = date;
        nextHolidayName = holidays.get(date);
        break;
      }
    }

    long daysRemaining = Days.daysBetween(referenceDate, nextHolidayDate).getDays();

    return new HolidayData(nextHolidayName, nextHolidayDate, daysRemaining);
  }

  private TreeMap<DateTime, String> getHolidaysForCurrentYear(DateTime now) {
    return getHolidaysForYear(now.getYear());
  }

  private TreeMap<DateTime, String> getHolidaysForYear(int year) {
    TreeMap<DateTime, String> holidays = new TreeMap<>();

    holidays.put(new DateTime(year, 1, 1, 0, 0), "New Year's Day");

    DateTime mlkDay = calculateNthDayOfWeek(year, 1, 3, 1); // 3rd Monday (1) in January
    holidays.put(mlkDay, "Martin Luther King Jr. Day");

    DateTime presidentsDay = calculateNthDayOfWeek(year, 2, 3, 1); // 3rd Monday (1) in February
    holidays.put(presidentsDay, "Presidents' Day");

    DateTime memorialDay = calculateLastDayOfWeek(year, 5, 1); // Last Monday (1) in May
    holidays.put(memorialDay, "Memorial Day");

    holidays.put(new DateTime(year, 7, 4, 0, 0), "Independence Day");

    DateTime laborDay = calculateNthDayOfWeek(year, 9, 1, 1); // 1st Monday (1) in September
    holidays.put(laborDay, "Labor Day");

    DateTime columbusDay = calculateNthDayOfWeek(year, 10, 2, 1); // 2nd Monday (1) in October
    holidays.put(columbusDay, "Columbus Day");

    holidays.put(new DateTime(year, 11, 11, 0, 0), "Veterans Day");

    DateTime thanksgivingDay =
        calculateNthDayOfWeek(year, 11, 4, 4); // 4th Thursday (4) in November
    holidays.put(thanksgivingDay, "Thanksgiving Day");

    holidays.put(new DateTime(year, 12, 25, 0, 0), "Christmas Day");

    return holidays;
  }

  private DateTime calculateNthDayOfWeek(int year, int month, int n, int dayOfWeek) {
    DateTime firstDayOfMonth = new DateTime(year, month, 1, 0, 0);
    int firstDayOfWeek = firstDayOfMonth.getDayOfWeek();

    int daysToAdd = (dayOfWeek - firstDayOfWeek + 7) % 7;

    return firstDayOfMonth.plusDays(daysToAdd).plusWeeks(n - 1);
  }

  private DateTime calculateLastDayOfWeek(int year, int month, int dayOfWeek) {
    DateTime firstDayOfNextMonth;
    if (month == 12) {
      firstDayOfNextMonth = new DateTime(year + 1, 1, 1, 0, 0);
    } else {
      firstDayOfNextMonth = new DateTime(year, month + 1, 1, 0, 0);
    }

    DateTime lastDayOfMonth = firstDayOfNextMonth.minusDays(1);

    int lastDayOfWeekValue = lastDayOfMonth.getDayOfWeek();
    int daysToSubtract = (lastDayOfWeekValue - dayOfWeek + 7) % 7;

    return lastDayOfMonth.minusDays(daysToSubtract);
  }
}
