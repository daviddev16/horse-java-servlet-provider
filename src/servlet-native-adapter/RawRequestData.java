package br.com.shopweb.h2s;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

public record RawRequestData(
    @JsonProperty("b") String body,
    @JsonProperty("c_t") String contentType,
    @JsonProperty("c_l") Integer contentLength,
    @JsonProperty("p_i") String pathInfo,
    @JsonProperty("m_t") String methodType,
    @JsonProperty("q_kv") List<String> queries,
    @JsonProperty("h_kv") List<String> headers,
    @JsonProperty("p_v") String protocolVersion,
    @JsonProperty("l_p") Integer localPort,
    @JsonProperty("l_h") String localHost,
    @JsonProperty("r_a") String remoteAddress,
    @JsonProperty("r_p") Integer remotePort,
    @JsonProperty("f_p") String fullPath,
    @JsonProperty("c_kv") List<String> cookies,
    @JsonProperty("q_s") String queryString) {}