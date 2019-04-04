/* -*- c++ -*- */

#define REDHAWK_INTEGRATION_API

%include "gnuradio.i"			// the common stuff

//load generated python docstrings
%include "redhawk_integration_swig_doc.i"

%{
#include "redhawk_integration/rh_sink_bulkio_c.h"
#include "redhawk_integration/rh_sink_bulkio_i.h"
#include "redhawk_integration/rh_sink_bulkio_f.h"
#include "redhawk_integration/rh_sink_bulkio_b.h"
#include "redhawk_integration/rh_sink_bulkio_s.h"
#include "redhawk_integration/rh_source_bulkio_c.h"
#include "redhawk_integration/rh_source_bulkio_i.h"
#include "redhawk_integration/rh_source_bulkio_f.h"
#include "redhawk_integration/rh_source_bulkio_b.h"
#include "redhawk_integration/rh_source_bulkio_s.h"
%}


// Sink templates
%include "redhawk_integration/rh_sink_bulkio_c.h"
%include "redhawk_integration/rh_sink_bulkio_i.h"
%include "redhawk_integration/rh_sink_bulkio_f.h"
%include "redhawk_integration/rh_sink_bulkio_b.h"
%include "redhawk_integration/rh_sink_bulkio_s.h"

GR_SWIG_BLOCK_MAGIC2(redhawk_integration, rh_sink_bulkio_c);
GR_SWIG_BLOCK_MAGIC2(redhawk_integration, rh_sink_bulkio_i);
GR_SWIG_BLOCK_MAGIC2(redhawk_integration, rh_sink_bulkio_f);
GR_SWIG_BLOCK_MAGIC2(redhawk_integration, rh_sink_bulkio_b);
GR_SWIG_BLOCK_MAGIC2(redhawk_integration, rh_sink_bulkio_s);

// Source templates
%include "redhawk_integration/rh_source_bulkio_c.h"
%include "redhawk_integration/rh_source_bulkio_i.h"
%include "redhawk_integration/rh_source_bulkio_f.h"
%include "redhawk_integration/rh_source_bulkio_b.h"
%include "redhawk_integration/rh_source_bulkio_s.h"

GR_SWIG_BLOCK_MAGIC2(redhawk_integration, rh_source_bulkio_c);
GR_SWIG_BLOCK_MAGIC2(redhawk_integration, rh_source_bulkio_i);
GR_SWIG_BLOCK_MAGIC2(redhawk_integration, rh_source_bulkio_f);
GR_SWIG_BLOCK_MAGIC2(redhawk_integration, rh_source_bulkio_b);
GR_SWIG_BLOCK_MAGIC2(redhawk_integration, rh_source_bulkio_s);
