FROM yavalek/drjack-wrf3:latest

ENV BASEDIR=/root/rasp/

WORKDIR /root/

ADD geog.tar.gz $BASEDIR

RUN cp -a $BASEDIR/region.TEMPLATE $BASEDIR/SEQ

COPY SEQ/wrfsi.nl SEQ/rasp.run.parameters.SEQ $BASEDIR/SEQ/
COPY SEQ/rasp.region_data.ncl $BASEDIR/GM/
COPY SEQ/rasp.site.runenvironment $BASEDIR/

ENV PATH="${BASEDIR}/bin:${PATH}"

# initialize
RUN cd $BASEDIR/SEQ/ \
  && wrfsi2wps.pl \
  && wps2input.pl \
  && geogrid.exe

# cleanup
RUN rm -rf $BASEDIR/geog

WORKDIR /root/rasp/

VOLUME ["/root/rasp/SEQ/OUT/", "/root/rasp/SEQ/LOG/"]

CMD ["runGM", "SEQ"]
