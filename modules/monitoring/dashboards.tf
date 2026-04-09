resource "kubernetes_config_map" "kafka_grafana_dashboard" {
  metadata {
    name      = "kafka-grafana-dashboard"
    namespace = var.prometheus_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "kafka-overview.json" = <<-JSON
      {
        "annotations": {
          "list": []
        },
        "editable": true,
        "fiscalYearStartMonth": 0,
        "graphTooltip": 0,
        "links": [],
        "panels": [
          {
            "datasource": {
              "type": "prometheus",
              "uid": "prometheus"
            },
            "fieldConfig": {
              "defaults": {
                "thresholds": {
                  "mode": "absolute",
                  "steps": [
                    { "color": "green", "value": null },
                    { "color": "red", "value": 0 }
                  ]
                },
                "color": { "mode": "thresholds" }
              },
              "overrides": []
            },
            "gridPos": { "h": 4, "w": 6, "x": 0, "y": 0 },
            "id": 1,
            "options": {
              "colorMode": "value",
              "graphMode": "none",
              "justifyMode": "auto",
              "textMode": "auto",
              "reduceOptions": {
                "calcs": ["lastNotNull"],
                "fields": "",
                "values": false
              }
            },
            "title": "Active Broker Count",
            "type": "stat",
            "targets": [
              {
                "expr": "count(kafka_server_replicamanager_leadercount)",
                "legendFormat": "Brokers",
                "refId": "A"
              }
            ]
          },
          {
            "datasource": {
              "type": "prometheus",
              "uid": "prometheus"
            },
            "fieldConfig": {
              "defaults": {
                "custom": {
                  "drawStyle": "line",
                  "lineInterpolation": "smooth",
                  "fillOpacity": 10,
                  "pointSize": 5,
                  "showPoints": "auto"
                },
                "unit": "ops"
              },
              "overrides": []
            },
            "gridPos": { "h": 8, "w": 12, "x": 0, "y": 4 },
            "id": 2,
            "options": {
              "legend": { "displayMode": "list", "placement": "bottom" },
              "tooltip": { "mode": "single" }
            },
            "title": "Messages In Per Second",
            "type": "timeseries",
            "targets": [
              {
                "expr": "sum(rate(kafka_server_brokertopicmetrics_messagesinpersec_count[5m])) by (topic)",
                "legendFormat": "{{topic}}",
                "refId": "A"
              }
            ]
          },
          {
            "datasource": {
              "type": "prometheus",
              "uid": "prometheus"
            },
            "fieldConfig": {
              "defaults": {
                "custom": {
                  "drawStyle": "line",
                  "lineInterpolation": "smooth",
                  "fillOpacity": 10,
                  "pointSize": 5,
                  "showPoints": "auto"
                },
                "unit": "Bps"
              },
              "overrides": []
            },
            "gridPos": { "h": 8, "w": 12, "x": 12, "y": 4 },
            "id": 3,
            "options": {
              "legend": { "displayMode": "list", "placement": "bottom" },
              "tooltip": { "mode": "single" }
            },
            "title": "Bytes Out Per Second",
            "type": "timeseries",
            "targets": [
              {
                "expr": "sum(rate(kafka_server_brokertopicmetrics_bytesoutpersec_count[5m])) by (topic)",
                "legendFormat": "{{topic}}",
                "refId": "A"
              }
            ]
          },
          {
            "datasource": {
              "type": "prometheus",
              "uid": "prometheus"
            },
            "fieldConfig": {
              "defaults": {
                "thresholds": {
                  "mode": "absolute",
                  "steps": [
                    { "color": "green", "value": null },
                    { "color": "orange", "value": 1 },
                    { "color": "red", "value": 5 }
                  ]
                },
                "color": { "mode": "thresholds" }
              },
              "overrides": []
            },
            "gridPos": { "h": 4, "w": 6, "x": 6, "y": 0 },
            "id": 4,
            "options": {
              "colorMode": "value",
              "graphMode": "area",
              "justifyMode": "auto",
              "textMode": "auto",
              "reduceOptions": {
                "calcs": ["lastNotNull"],
                "fields": "",
                "values": false
              }
            },
            "title": "Under-Replicated Partitions",
            "type": "stat",
            "targets": [
              {
                "expr": "sum(kafka_server_replicamanager_underreplicatedpartitions)",
                "legendFormat": "Under-replicated",
                "refId": "A"
              }
            ]
          }
        ],
        "schemaVersion": 39,
        "tags": ["kafka", "confluent"],
        "templating": { "list": [] },
        "time": { "from": "now-1h", "to": "now" },
        "title": "Kafka Overview",
        "uid": "kafka-overview",
        "version": 1
      }
    JSON
  }
}
