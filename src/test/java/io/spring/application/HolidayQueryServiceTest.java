package io.spring.application;

import static org.junit.Assert.*;

import io.spring.application.data.HolidayData;
import org.joda.time.DateTime;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class HolidayQueryServiceTest {

  @Autowired private HolidayQueryService holidayQueryService;

  @Test
  public void should_return_next_holiday() {
    HolidayData nextHoliday = holidayQueryService.findNextHoliday();

    assertNotNull(nextHoliday);
    assertNotNull(nextHoliday.getName());
    assertNotNull(nextHoliday.getDate());
    assertTrue(nextHoliday.getDate().isAfterNow());
    assertTrue(nextHoliday.getDaysRemaining() >= 0);
  }

  @Test
  public void should_return_next_holiday_from_reference_date() {
    DateTime referenceDate = new DateTime(2024, 1, 1, 0, 0);
    HolidayData nextHoliday = holidayQueryService.findNextHoliday(referenceDate);

    assertNotNull(nextHoliday);
    assertEquals("Martin Luther King Jr. Day", nextHoliday.getName());
    assertEquals(new DateTime(2024, 1, 15, 0, 0), nextHoliday.getDate());
    assertEquals(14, nextHoliday.getDaysRemaining());
  }
}
