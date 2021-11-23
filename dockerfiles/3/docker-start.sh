#!/bin/bash

/xsweet/kibana/bin/kibana &
/xsweet/elasticsearch/bin/elasticsearch &
/xsweet/logstash/bin/logstash -f /xsweet/logstash/logstash.conf 