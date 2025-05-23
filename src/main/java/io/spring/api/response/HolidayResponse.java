package io.spring.api.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonRootName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonRootName("holiday")
@JsonIgnoreProperties({"hoursRemaining", "minutesRemaining", "secondsRemaining"})
public class HolidayResponse {
  private String name;
  private String date;
  private long daysRemaining;
}
