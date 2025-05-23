package io.spring.application;

import static org.junit.Assert.*;

import io.spring.application.data.HolidayData;
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
}
