# REDHAWK Integration Package

This OOT module for GNURadio provides the following blocks for integrating with a REDHAWK Waveform:

 1. `rh_source_bulkio` -- Data coming from REDHAWK SDR
 2. `rh_sink_bulkio` -- Data going to REDHAWK SDR

Each is intended to replace any data streaming elements that may have been required in the Flow Graph that will be sourced (or sinked) from (or to) a Device in the REDHAWK Domain.  The blocks themselves take pointers to REDHAWK BULKIO Ports and use the Streaming API, using the `gr-component_converter`([link][converter]).

This package is based on a mix of the original `gr-redhawk_integration_python` and Rodrigo455's [Wideband FM examples][wbfm].  The `rh_sink/source_bulkio.h` files have been imported and converted to templates here, and then extended to use the BULKIO Streaming interface to provide performance features like shared address space.

## Requirements

The supported framework versions at this time are:

 1. REDHAWK SDR 2.2.0
 2. GNURadio 3.7.12.0

## Installation

To install the OOT module, run the install make target after configuring cmake:

**Source or Package Manager Installations**

```
mkdir build && cd build
cmake <path>gr-redhawk_integration
[sudo] make install
```

**Pybombs Installations**

```
mkdir build && cd build
cmake <path>gr-redhawk_integration
source <your prefix>/setup_env.sh
make install
```

 > **Note:** Pybombs users (generally) do not need to be root to install the integration package since it's likely owned by one's own user.

## Source

The `rh_source_bulkio` block represents an input (Provides) port in REDHAWK.  Using the [converter][converter], this block receives a reference to the surrounding Component's port.

### Parameters

| Key | End User | Required | Definition |
| -------- | -------- | -------- | ---------- |
| port | No | Yes | A BULKIO::InNumericPort<T> from the parent Component |
| packet_depth | Yes | No | Number of BulkIO packets to allow to queue |


### Special Notes

This block translates the incoming SRI, acquisition timestamp, and other details using into a stream tag.  These tags are then pushed only if the SRI changes (to reduce overhead).  The SRI contains a variety of information related to sample rate, subsize information (if the data is a matrix) as well as units for the data (Hz, seconds, dB, etc.).  Please refer to the [REDHAWK Documentation][redhawk-docs] for details on these structures.

 > **Important Note:** In REDHAWK, every BULKIO Time Stamp is passed with almost no processing cost.  Because we can only pass that structure as a stream tag, which cannot be pushed constantly without a large penalty, the time stamp is only pushed if the SRI's information changes.

## Sink

The `rh_sink_bulkio` block represents an output (Uses) port in REDHAWK.  Using the [converter][converter], this block receives a reference to the surrounding Component's port.

### Parameters

| Key | End User | Required | Definition |
| -------- | -------- | -------- | ---------- |
| port | No | Yes | A BULKIO::OutNumericPort<T> from the parent Component |
| sri | Yes | No | The Signal Related Information (SRI, multiple parameters) |

### Special Notes

This block **requires** that at least one [stream tag](#tag-utils) has been received to define the number of samples in a packet.  If none is provided the port will never empty the incoming buffer or push a packet.

 > **Important Note:** Because conveying every timestamp change through stream tagging would carry a significant perfomance cost, the time stamp provided by this block to REDHAWK is created at the same time the packet is pushed (i.e., we're re-stamping time).

 > **Important Note:** If no stream tag provides an SRI, the default SRI is used.  This will likely cause problems if there are downstream REDHAWK Components or Devices ingesting the data stream.  Please consider populating the SRI parameters on the block.


[converter]: https://github.com/GeonTech/gr-component_converter
[wbfm]: https://github.com/rodrigo455/gnuradio-nbfm
[redhawk-docs]:  http://redhawksdr.github.io/Documentation/mainch5.html
