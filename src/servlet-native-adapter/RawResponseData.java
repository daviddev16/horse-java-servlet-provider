package io.h2s;

import com.fasterxml.jackson.annotation.JsonProperty;

public record RawResponseData(
    @JsonProperty("b") String body,
    @JsonProperty("s_c") Integer statusCode,
    @JsonProperty("c_t") String contentType) { }
