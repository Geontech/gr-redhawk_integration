/* -*- c++ -*- */
/* 
 * Author: Rodrigo Rolim Mendes de Alencar <alencar.fmce@imbel.gov.br>
 *
 * Copyright 2018 IMBEL/FMCE; Geon Technologies, LLC
 * 
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 * 
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 *
 * Additions by Geon Technologies for templating into a GNURadio OOT module
 * using the REDHAWK Streaming BULKIO API.
 */

#ifndef @GUARD_NAME@
#define @GUARD_NAME@

#include <redhawk_integration/api.h>
#include <gnuradio/sync_block.h>
#include <bulkio/bulkio.h>
#include <ossie/CorbaUtils.h>
#include <ossie/logging/loghelpers.h>

namespace gr {
    namespace redhawk_integration {

        /*!
         * \brief Ingests data from GNURadio and outputs it into REDHAWK via the BULKIO Stream API
         * \ingroup redhawk_integration
         *
         */
        class REDHAWK_INTEGRATION_API @BASE_NAME@ : virtual public gr::sync_block {
        private:
            bulkio::OutNumericPort<@REDHAWK_BULKIO_TYPE@>* port;
            bulkio::NumericOutputStream<@REDHAWK_BULKIO_TYPE@> stream;

        public:
            typedef boost::shared_ptr<@BASE_NAME@ > sptr;

            @BASE_NAME@(const std::string& stream_id, long xunits, double xdelta, long yunits, double ydelta, long subsize) :
            gr::sync_block("@BASE_NAME@",
            gr::io_signature::make(1, 1, sizeof(@TYPE@)),
            gr::io_signature::make(0, 0, 0)) {
                // Must initialize the block's ORB and logging
                CORBA::ORB_ptr orb = ossie::corba::CorbaInit(0, NULL);
                ossie::logging::Configure();

                // Create the port, SRI and stream
                std::ostringstream port_name;
                port_name << name() << '_' << unique_id();
                port = new bulkio::OutNumericPort<@REDHAWK_BULKIO_TYPE@>(port_name.str());
                PortableServer::POA_var poa = port->_default_POA();
                PortableServer::ObjectId_var oid = poa->activate_object(port);
                BULKIO::StreamSRI sri = bulkio::sri::create(stream_id);
                sri.xunits  = xunits;
                sri.xdelta  = xdelta;
                sri.yunits  = yunits;
                sri.ydelta  = ydelta;
                sri.subsize = subsize;
                stream = port->createStream(sri);
            }
            ~@BASE_NAME@();

            /* REDHAWK calls getPort */
            std::string getPort() {
                std::ostringstream os;
                if (port) { 
                    PortableServer::POA_var poa = port->_default_POA();
	            PortableServer::ObjectId_var oid = poa->servant_to_id(port);
	            for (size_t i=0; i<oid->length(); ++i) {
		        os << oid[i];
	            }
                } 
                return os.str();
            }

            static sptr make(const std::string& stream_id, long xunits, double xdelta, long yunits, double ydelta, long subsize);
            int work(int noutput_items, gr_vector_const_void_star &input_items, gr_vector_void_star &output_items);
        };

        @BASE_NAME@::sptr
        @BASE_NAME@::make(const std::string& stream_id, long xunits, double xdelta, long yunits, double ydelta, long subsize) {
            return gnuradio::get_initial_sptr(new @BASE_NAME@(stream_id, xunits, xdelta, yunits, ydelta, subsize));
        }

        @BASE_NAME@::~@BASE_NAME@() {
            port->_remove_ref();
            port = NULL;
        }

        int @BASE_NAME@::work(int noutput_items,
                gr_vector_const_void_star &input_items,
                gr_vector_void_star &output_items) {
            if (port->isActive()) {
                const @TYPE@ *in = (const @TYPE@*) input_items[0];
                redhawk::buffer<@TYPE@ > out(noutput_items);
                for (size_t i=0; i < noutput_items; ++i) {
                    out[i] = in[i];
                }
                stream.write(out, bulkio::time::utils::now());
            }

            consume_each(noutput_items);

            return 0;
        }
        
    } // namespace redhawk_integration
} // namespace gr

#endif /* @GUARD_NAME@ */
