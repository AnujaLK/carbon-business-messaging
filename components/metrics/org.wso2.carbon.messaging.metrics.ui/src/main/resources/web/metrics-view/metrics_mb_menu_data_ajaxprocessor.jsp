
<%
    /*
     * Copyright 2015 WSO2 Inc. (http://wso2.org)
     * 
     * Licensed under the Apache License, Version 2.0 (the "License");
     * you may not use this file except in compliance with the License.
     * You may obtain a copy of the License at
     * 
     *     http://www.apache.org/licenses/LICENSE-2.0
     * 
     * Unless required by applicable law or agreed to in writing, software
     * distributed under the License is distributed on an "AS IS" BASIS,
     * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     * See the License for the specific language governing permissions and
     * limitations under the License.
     */
%>
<%@page import="java.io.OutputStreamWriter"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.wso2.carbon.metrics.data.common.MetricList"%>
<%@ page import="org.wso2.carbon.metrics.data.common.Metric"%>
<%@ page import="org.wso2.carbon.metrics.data.common.MetricType"%>
<%@ page import="org.wso2.carbon.metrics.data.common.MetricAttribute"%>
<%@ page import="org.wso2.carbon.metrics.data.common.MetricDataFormat"%>
<%@ page import="org.wso2.carbon.metrics.view.ui.MetricsViewClient"%>
<%@ page import="org.wso2.carbon.metrics.view.ui.MetricDataWrapper"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="org.apache.axis2.context.ConfigurationContext"%>
<%@ page import="org.wso2.carbon.CarbonConstants"%>
<%@ page import="org.wso2.carbon.utils.ServerConstants"%>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil"%>
<%@ page import="org.wso2.carbon.utils.CarbonUtils"%>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage"%>

<%
    String source = request.getParameter("source");
    String from = request.getParameter("from");
    String type = request.getParameter("type");

    String backendServerURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
    ConfigurationContext configContext = (ConfigurationContext) config.getServletContext().getAttribute(
            CarbonConstants.CONFIGURATION_CONTEXT);
    String cookie = (String) session.getAttribute(ServerConstants.ADMIN_SERVICE_COOKIE);
    MetricsViewClient metricsViewClient;
    try {
        metricsViewClient = new MetricsViewClient(cookie, backendServerURL, configContext);
        Gson gson = new Gson();
        MetricDataWrapper metricData = null;
        ArrayList<Metric> metrics = new ArrayList<Metric>();
        if ("Disruptor".equals(type)) {
            metrics.add(new Metric(MetricType.GAUGE, "org.wso2.mb.inbound.disruptor.message.count",
                    "Total Messages in Inbound Disruptor", MetricAttribute.VALUE, null));
            metrics.add(new Metric(MetricType.GAUGE, "org.wso2.mb.inbound.disruptor.ack.count",
                    "Total Acks in Inbound Disruptor", MetricAttribute.VALUE, null));
            metrics.add(new Metric(MetricType.GAUGE, "org.wso2.mb.outbound.disruptor.message.count",
                    "Total Messages in Outbound Disruptor", MetricAttribute.VALUE, null));
        } else if ("PubSub".equals(type)) {
            metrics.add(new Metric(MetricType.GAUGE, "org.wso2.mb.queue.subscribers.count",
                    "Total Queue Subscribers", MetricAttribute.VALUE, null));
            metrics.add(new Metric(MetricType.GAUGE, "org.wso2.mb.topic.subscribers.count",
                    "Total Topic Subscribers", MetricAttribute.VALUE, null));
            metrics.add(new Metric(MetricType.GAUGE, "org.wso2.mb.channels.active.count", "Total Channels",
                    MetricAttribute.VALUE, null));
        } else if ("MsgAckRecv".equals(type)) {
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.message.receive",
                    "Received Messages Mean Rate", MetricAttribute.MEAN_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.message.receive",
                    "Received Messages Last Minute Rate", MetricAttribute.M1_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.message.receive",
                    "Received Messages Last 5 Minutes Rate", MetricAttribute.M5_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.message.receive",
                    "Received Messages Last 15 Minutes Rate", MetricAttribute.M15_RATE, null));

            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.ack.receive",
                    "Received Acknowledgements Mean Rate", MetricAttribute.MEAN_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.ack.receive",
                    "Received Acknowledgements Last Minute Rate", MetricAttribute.M1_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.ack.receive",
                    "Received Acknowledgements Last 5 Minutes Rate", MetricAttribute.M5_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.ack.receive",
                    "Received Acknowledgements Last 15 Minutes Rate", MetricAttribute.M15_RATE, null));
        } else if ("MsgAckSent".equals(type)) {
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.message.sent", "Sent Messages Mean Rate",
                    MetricAttribute.MEAN_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.message.sent",
                    "Sent Messages Last Minute Rate", MetricAttribute.M1_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.message.sent",
                    "Sent Messages Last 5 Minutes Rate", MetricAttribute.M5_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.message.sent",
                    "Sent Messages Last 15 Minutes Rate", MetricAttribute.M15_RATE, null));

            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.ack.sent", "Sent Acknowledgements Mean Rate",
                    MetricAttribute.M1_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.ack.sent",
                    "Sent Acknowledgements Last Minute Rate", MetricAttribute.M1_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.ack.sent",
                    "Sent Acknowledgements Last 5 Minutes Rate", MetricAttribute.M5_RATE, null));
            metrics.add(new Metric(MetricType.METER, "org.wso2.mb.ack.sent",
                    "Sent Acknowledgements Last 15 Minutes Rate", MetricAttribute.M15_RATE, null));
        } else if ("DatabaseRead".equals(type)) {
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read", "Minimum Database Read Time",
                    MetricAttribute.MIN, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read", "Mean Database Read Time",
                    MetricAttribute.MEAN, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read", "Maximum Database Read Time",
                    MetricAttribute.MAX, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read",
                    "Standard Deviation of Database Read Time", MetricAttribute.STDDEV, null));

            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read",
                    "Database Read Time 50th Percentile", MetricAttribute.P50, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read",
                    "Database Read Time 75th Percentile", MetricAttribute.P75, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read",
                    "Database Read Time 95th Percentile", MetricAttribute.P95, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read",
                    "Database Read Time 98th Percentile", MetricAttribute.P98, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read",
                    "Database Read Time 99th Percentile", MetricAttribute.P99, null));
            // Charts did not work when display name had "99.9"
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read",
                    "Database Read Time 999th Percentile", MetricAttribute.P999, null));

            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read", "Database Read Mean Rate",
                    MetricAttribute.MEAN_RATE, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read",
                    "Database Read Last Minute Rate", MetricAttribute.M1_RATE, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read",
                    "Database Read Last 5 Minutes Rate", MetricAttribute.M5_RATE, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.read",
                    "Database Read Last 15 Minutes Rate", MetricAttribute.M15_RATE, null));
        } else if ("DatabaseWrite".equals(type)) {
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Minimum Database Write Time", MetricAttribute.MIN, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write", "Mean Database Write Time",
                    MetricAttribute.MEAN, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Maximum Database Write Time", MetricAttribute.MAX, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Standard Deviation of Database Write Time", MetricAttribute.STDDEV, null));

            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Database Write Time 50th Percentile", MetricAttribute.P50, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Database Write Time 75th Percentile", MetricAttribute.P75, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Database Write Time 95th Percentile", MetricAttribute.P95, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Database Write Time 98th Percentile", MetricAttribute.P98, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Database Write Time 99th Percentile", MetricAttribute.P99, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Database Write Time 999th Percentile", MetricAttribute.P999, null));

            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write", "Database Write Mean Rate",
                    MetricAttribute.MEAN_RATE, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Database Write Last Minute Rate", MetricAttribute.M1_RATE, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Database Write Last 5 Minutes Rate", MetricAttribute.M5_RATE, null));
            metrics.add(new Metric(MetricType.TIMER, "org.wso2.mb.database.write",
                    "Database Write Last 15 Minutes Rate", MetricAttribute.M15_RATE, null));
        }

        MetricList metricList = new MetricList();
        metricList.setMetric(metrics.toArray(new Metric[metrics.size()]));
        metricData = metricsViewClient.findLastMetrics(metricList, source, from);
        if (metricData != null) {
            response.getWriter().write(gson.toJson(metricData));
        }
    } catch (Exception e) {
        return;
    }

    response.setContentType("application/json");
%>
