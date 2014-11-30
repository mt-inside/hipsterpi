#!/bin/bash

puppet apply --modulepath $(dirname $0)/modules $(dirname $0)/manifests/site.pp
